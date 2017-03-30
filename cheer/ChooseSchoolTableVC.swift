//
//  ChooseSchoolTableVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/3/27.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class ChooseSchoolTableVC: UITableViewController {
    
    let searchBar = UISearchBar()
    var filteredSchools = [String]()
    var schools = [String]()
    var tap: UITapGestureRecognizer!
    var selectedSchool: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = "Search school name"
        searchBar.returnKeyType = .done
        searchBar.keyboardType = .asciiCapable
        
        // solve the problem that search bar flashes
        searchBar.barTintColor = UIColor.clear
        searchBar.isTranslucent = true
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        searchBar.delegate = self
        for data in SchoolData.schoolData{
            schools.append(data.key)
        }
        schools.sort()
        tableView.register(UINib(nibName: "SchoolCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        // set up observers
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseSchoolTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseSchoolTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // set up gesture recognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(ChooseSchoolTableVC.dismissKeyboard))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneIsPushed(_ sender: UIBarButtonItem) {
        if selectedSchool != nil{
            UserDefaults.standard.set(selectedSchool!, forKey: "selectedSchool")
            self.dismiss(animated: true, completion: nil)
        }
        else{
            Alert.displayAlertWithOneButton(title: "Error", message: "Please select a school", vc: self)
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.addGestureRecognizer(tap)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.removeGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        searchBar.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchBar.text! != "" ? 1 : SchoolData.states.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.text! != "" ? filteredSchools.count : SchoolData.schools[SchoolData.states[section]]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! SchoolCell
        let name = searchBar.text! != "" ? filteredSchools[indexPath.row] : SchoolData.schools[SchoolData.states[indexPath.section]]![indexPath.row]
        cell.schoolName.text = name
        cell.logo.image = SchoolData.schoolData[name]![0]
        cell.background.image = SchoolData.schoolData[name]![1]
        if selectedSchool != nil && selectedSchool! == name{
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchBar.text! != "" ? "" : SchoolData.states[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SchoolCell
        selectedSchool = cell.schoolName.text!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ChooseSchoolTableVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSchools.removeAll(keepingCapacity: false)
        for school in schools{
            if school.lowercased().contains(searchBar.text!.lowercased()){
                filteredSchools.append(school)
            }
        }
        self.tableView.reloadData()
    }
}
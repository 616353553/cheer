//
//  FirstViewController.swift
//  cheer
//
//  Created by Sophie on 2017/5/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirstViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, RestfulRequestManagerDelegate{
    var ref: FIRDatabaseReference!
    var requestManager = RestfulRequestManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewData: [(String, String)] = [(">_< Search", "Your Course")]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func touch_cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()

        ref.child("course/-KmZ64ClZ4fPPnLffVzF/").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            print("end event")
            let value = snapshot.value as! NSDictionary
            let courseSectionInformation = value["courseSectionInformation"] as! String
            print(courseSectionInformation)
            print("end print")
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        print(searchBar.text!)
        
        let result = searchCourse(text: searchText)
        // display result
        
//        tableViewData = result
//        tableView.reloadData()
        
        print(result)
        // display result end
        
        
    }

    var coursesDatabase = [("CS225", "Data Structure"), ("CS446", "Machine Learning"), ("CS233", "Comptuer Architecture")]
    
    func getResultFromData(data: Any) -> Any {
        var result = [(String, String)]()
        for item in (data as! [String]){
            let c = item.characters.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
            let tuple = ("\(String(c[0])) \(String(c[1]))", String(c[2]))
            result.append(tuple)
        }
        return result
    }
    
    func presentResult(result: Any) {
        if let result = result as? [(String,String)]{
            tableViewData = result
            tableView.reloadData()
        }
    }
    
    func searchCourse(text: String)->[(String, String)]{
        requestManager.request(endPoint: "search", params: ["query":text])
        return []
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        cell.tag = indexPath.row
        let (courseNum, courseName) = tableViewData[indexPath.row]
        cell.textLabel?.text = "\(courseNum) \(courseName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let id = segue.identifier{
            switch id {
            case "toSection":
                let d = segue.destination as! SelectionViewController
                let s = sender as! UITableViewCell
                let i = s.tag
                d.name = tableViewData[i].1
                d.id = tableViewData[i].0
            default:
                break
            }
        }
    }
    
    func print_json(data: Data?){
        do {
            let json_text = try JSONSerialization.jsonObject(with: data!)
            print(json_text)
        } catch {
            print("nil")
        }
    }

}

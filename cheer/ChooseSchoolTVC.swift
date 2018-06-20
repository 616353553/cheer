//
//  ChooseSchoolTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol ChooseSchoolTVCDelegate {
    func schoolChoosed(schoolName: String)
}

class ChooseSchoolTVC: UITableViewController {
    
    private var tap: UITapGestureRecognizer!
    private var selectedSchool: String?
    private var schoolData: [(key: String, value: [School])] = []
    private var refresher: UIRefreshControl!
    var delegate: ChooseSchoolTVCDelegate!
    
    @IBAction func doneIsPushed(_ sender: UIBarButtonItem) {
        if selectedSchool == nil {
            Alert.displayAlertWithOneButton(title: "Error", message: "Please select a school", vc: self)
        } else {
            self.delegate.schoolChoosed(schoolName: selectedSchool!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SchoolCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.tableFooterView = UIView(frame: .zero)
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Fetching School Data",
                                                       attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 10.0)!,
                                                                    NSForegroundColorAttributeName: UIColor.lightGray])
        refresher.addTarget(self, action: #selector(fetchData(_:)), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refresher
        tableView.setContentOffset(CGPoint.init(x: 0, y: -refresher.frame.height), animated: true)
        refresher.beginRefreshing()
        fetchData(refresher)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData(_ refreshControl: UIRefreshControl) {
        let request = Request(requestType: .json, endPoint: "get_school_data", body: nil, userToken: nil) { (data, error) in
            if error != nil {
                Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: self)
            } else {
                self.schoolData.removeAll()
                self.schoolParser(data: data!)
                refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
        request.start()
    }
    
    
    func schoolParser(data: [String: Any]) {
        var schools = [String: [School]]()
        for schoolData in data {
            var school: School?
            if let schoolInfo = schoolData.value as? [String: String] {
                school = School(fullName: schoolInfo["fullName"],
                                logoRef: schoolInfo["logoRef"],
                                state: schoolInfo["state"],
                                teacherList: schoolInfo["teacherList"])
            }
            if let school = school {
                if schools[school.getState()] != nil {
                    schools[school.getState()]!.append(school)
                } else {
                    schools[school.getState()] = [school]
                }
            }
        }
        self.schoolData = schools.sorted(by: {$0.0 < $1.0})
    }

    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schoolData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolData[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! SchoolCell
        let school = schoolData[indexPath.section].value[indexPath.row]
        if let logoImage = school.getLogo() {
            cell.updateCell(logo: logoImage, schoolName: school.getFullName())
        } else {
            school.fetchLogo(completion: { (data, error) in
                if data != nil {
                    cell.updateCell(logo: school.getLogo(), schoolName: school.getFullName())
                }
            })
        }
        cell.setSelected(selectedSchool == school.getFullName(), animated: false)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return schoolData[section].key
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSchool = schoolData[indexPath.section].value[indexPath.row].getFullName()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.groupTableViewBackground
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // do something?
    }
}

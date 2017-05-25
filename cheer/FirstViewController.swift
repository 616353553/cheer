//
//  FirstViewController.swift
//  cheer
//
//  Created by Sophie on 2017/5/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewData: [(String, String)] = [("CS446", "No Course!!!!!!!")]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        print(searchBar.text!)
        
        let result = searchCourse(text: searchText)
        // display result
        
        tableViewData = result
        tableView.reloadData()
        
        print(result)
        // display result end
    }

    var coursesDatabase = [("CS225", "Data Structure"), ("CS446", "Machine Learning"), ("CS233", "Comptuer Architecture")]
    
    func searchCourse(text: String)->[(String, String)]{
        // C  // 225 // C Data // 
        // CS225 // CS 225 // CS Data S
        var result : [(String, String)] = []
        //
        
        for (courseNumber, courseName) in coursesDatabase{
            if courseNumber.contains(text) {
                result.insert((courseNumber, courseName), at: 0)
            }
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

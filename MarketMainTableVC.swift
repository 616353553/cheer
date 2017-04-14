//
//  MarketMainTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class MarketMainTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        createSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func addPostIsPushed(_ sender: UIBarButtonItem) {
        if FIRAuth.auth()?.currentUser == nil{
            print("login please")
        }
        else{
            performSegue(withIdentifier: "addPost", sender: self)
        }
    }
    
    func setUpTableView(){
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }

    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for items"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return self.view.frame.height/4
//        }
//        return self.view.frame.height * 0.55
//    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
        case "postItem":
            self.tabBarController?.tabBar.isHidden = true
        default:
            break
        }
    }

}

// MARK: - Search Bar Delegate

extension MarketMainTableVC: UISearchBarDelegate{
    
}


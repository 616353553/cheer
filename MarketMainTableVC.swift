//
//  MarketMainTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MarketMainTableVC: UITableViewController {

    //var items: [Item]!
    var items_test: [Item]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
        items_test = [Item]()
        print("b")
        let ref = Database.database().reference().child(UserDefaults.standard.string(forKey: "selectedSchool")!).child("Items")
        ref.observe(.value, with: {(snapshot) in
            for child in snapshot.children{
                let itemData = child as! DataSnapshot
                let item = Item()
                item.initialize(snapshot: itemData)
                self.items_test.append(item)
            }
            print(self.items_test.count)
            self.tableView.reloadData()
        })
        
        
        
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
        if Auth.auth().currentUser == nil{
            print("login please?!")
        }else{
            performSegue(withIdentifier: "addPost", sender: self)
        }
    }

    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for items"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
//    func loadData(){
//        items = [Item]()
//        let ref = FIRDatabase.database().reference().child(UserDefaults.standard.string(forKey: "selectedSchool")!).child("Items")
//        ref.observe(.value, with: {(snapshot) in
//            for child in snapshot.children{
//                let itemData = child as! FIRDataSnapshot
//                let item = Item()
//                item.initialize(snapshot: itemData)
//                self.items.append(item)
//            }
//            print(self.items.count)
//            self.tableView.reloadData()
//        })
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items_test.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if items_test[indexPath.row].images.numOfImages > 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "withImage", for: indexPath) as! ItemWithImageCell
//            cell.item = items_test[indexPath.row]
//            cell.updateCell()
//            cell.layoutSubviews()
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "withoutImage", for: indexPath) as! ItemWithoutImageCell
//            cell.item = items_test[indexPath.row]
//            cell.updateCell()
//            cell.layoutSubviews()
//            return cell
//        }
        return UITableViewCell()
    }
//    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if items[indexPath.row].images.numOfImages > 0{
//            let cell = cell as! ItemWithImageCell
//            cell.updateCell()
//        }else{
//            let cell = cell as! ItemWithoutImageCell
//            cell.updateCell()
//        }
//    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
        case "postItem":
            self.tabBarController?.tabBar.isHidden = true
        case "test":
            print("test")
        default:
            break
        }
    }

}

// MARK: - Search Bar Delegate

extension MarketMainTableVC: UISearchBarDelegate{
    
}


//
//  HomeMainTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class HomeMainTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // show log in view if no school is selected
        if UserDefaults.standard.string(forKey: "selectedSchool") == nil{
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "signIn") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func setUpTableView(){
        tableView.register(UINib(nibName: "ScrollViewTableViewCell", bundle: nil), forCellReuseIdentifier: "adsCell")
        tableView.register(UINib(nibName: "HotItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "hotItemsCell")
        tableView.register(UINib(nibName: "HotActivitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "hotActivitiesCell")
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "adsCell", for: indexPath) as! ScrollViewTableViewCell
        }
        else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "hotItemsCell", for: indexPath) as! HotItemsTableViewCell
        }
        else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "hotActivitiesCell", for: indexPath) as! HotActivitiesTableViewCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return self.view.frame.height/4
        }
        return self.view.frame.height * 0.55
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


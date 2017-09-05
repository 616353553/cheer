//
//  MePersonalInfoTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class MePersonalInfoTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]:
            performSegue(withIdentifier: "toPortrait", sender: self)
        case [0, 1]:
            performSegue(withIdentifier: "toNickname", sender: self)
        case [0, 2]:
            performSegue(withIdentifier: "toQRCode", sender: self)
        case [1, 0]:
            performSegue(withIdentifier: "toGender", sender: self)
        case [1, 1]:
            performSegue(withIdentifier: "toDescription", sender: self)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil {
            switch segue.identifier! {
            case "toPortrait":
                let vc = segue.destination as! MePortraitVC
                // vc.userProfile =
            case "toNickname":
                let vc = segue.destination as! MeNicknameTVC
            case "toQRCode":
                let vc = segue.destination as! MeQRCodeVC
            case "toGender":
                let vc = segue.destination as! MeGenderTVC
            case "toDescription":
                let vc = segue.destination as! MeDescriptionTVC
            default:
                break
            }
        }
    }
}

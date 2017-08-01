//
//  CreateGroupRulesTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupRulesTVC: UITableViewController {
    
    @IBOutlet var checks: [UIImageView]!
    @IBAction func submitPushed(_ sender: UIBarButtonItem) {
        if group!.isValidGroup() {
            let spinner = UIActivityIndicatorView()
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            group.upload() {(error, data) in
                Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
                if error == nil {
                    Alert.displayAlertWithOneButton(title: "Success", message: "Your group is created successfully", vc: self) {(action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    Alert.displayAlertWithOneButton(title: "Error", message: error!, vc: self)
                }
            }
        } else {
            Alert.displayAlertWithOneButton(title: "Unknown Error", message: "Please try again later", vc: self)
        }
    }
    
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCheckMark()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateCheckMark() {
        var checkMarkTag = 1
        if group!.getSendNotification() {
            checkMarkTag = 0
        }
        for check in checks {
            check.isHidden = (check.tag != checkMarkTag)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            group!.setSendNotification(sendNotification: true)
        case 1:
            group!.setSendNotification(sendNotification: false)
        default:
            break
        }
        updateCheckMark()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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

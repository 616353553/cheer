//
//  GroupCreateTypeTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/18.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class GroupCreateTypeTVC: UITableViewController {
    
    @IBOutlet var checks: [UIImageView]!

    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        group = Group(creatorID: Auth.auth().currentUser!.uid)
        setCheckMarks()
        // disable navigation controller dismiss on swipe action
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setCheckMarks(){
        if let groupType = group.getGroupType() {
            for check in checks {
                check.isHidden = (check.tag != groupType.hashValue)
            }
        } else {
            for check in checks {
                check.isHidden = true
            }
        }
    }
    
    @IBAction func cancelIsPushed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextIsPushed(_ sender: UIBarButtonItem) {
        next()
        //print("next")
    }
    
    private func next(){
        if group.getGroupType() != nil {
            performSegue(withIdentifier: "toTitle", sender: self)
        } else {
            Alert.displayAlertWithOneButton(title: "Warning", message: "Please select a group type", vc: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]:
            group!.setGroupType(groupType: .activity)
            setCheckMarks()
        case [0, 1]:
            group!.setGroupType(groupType: .project)
            setCheckMarks()
        case [0, 2]:
            group!.setGroupType(groupType: .research)
            setCheckMarks()
        case [1, 0]:
            next()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        case 1:
            return 0.1
        default:
            return 0
        }
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toTitle":
                let vc = segue.destination as! CreateGroupTitleVC
                vc.group = group
            default:
                break
            }
        }
    }
}

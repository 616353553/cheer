//
//  GroupCreateTypeTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/18.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupCreateTypeTVC: UITableViewController {
    
    @IBOutlet var checks: [UIImageView]!

    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        group = Group()
        group!.initialize(groupType: .professorProject)
        setCheckMarks()
        // disable navigation controller dismiss on swipe action
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setCheckMarks(){
        for check in checks{
            if check.tag == group!.getGroupType().hashValue {
                check.isHidden = false
            } else {
                check.isHidden = true
            }
        }
    }
    
    @IBAction func cancelIsPushed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextIsPushed(_ sender: UIBarButtonItem) {
        next()
    }
    
    func next(){
        performSegue(withIdentifier: "toTitle", sender: self)
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
            group!.setGroupType(groupType: .professorProject)
            setCheckMarks()
        case [0, 1]:
            group!.setGroupType(groupType: .studentProject)
            setCheckMarks()
        case [0, 2]:
            group!.setGroupType(groupType: .activity)
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

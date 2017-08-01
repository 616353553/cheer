//
//  CreateGroupScheduleTypeTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/8.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupScheduleTypeTVCDelegate {
    func typeSelected(newType: ScheduleRepeatingType)
}

class CreateGroupScheduleTypeTVC: UITableViewController {

    @IBOutlet var checks: [UIImageView]!
    
    var repeatType: ScheduleRepeatingType?
    var delegate: CreateGroupScheduleTypeTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for check in checks {
            check.isHidden = (check.tag != repeatType!.hashValue)
        }
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            repeatType = .repeatByDay
        case 1:
            repeatType = .repeatByWeek
        case 2:
            repeatType = .repeatByMonth
        default:
            break
        }
        delegate!.typeSelected(newType: repeatType!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
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

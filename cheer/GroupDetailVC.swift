//
//  GroupDetailVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum GroupDetailCellType {
    case headerCell
    case queueCell
    case scheduleCell
    case requirementCell
    case descriptionCell
    case locationCell
    case contactCell
}

class GroupDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func queuePushed(_ sender: UIButton) {
        print("BB")
    }
    
    @IBAction func joinPushed(_ sender: UIButton) {
        print("CC")
    }
    
    @IBAction func bookmarkPushed(_ sender: UIButton) {
        print("DD")
    }
    
    @IBAction func commentPushed(_ sender: UIButton) {
        print("AA")
        let storyboard = UIStoryboard.init(name: "Comment", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentMainTVC") as! CommentMainTVC
        vc.comments = CommentList()
        vc.comments.initialize(directory: group.getCommentList(), numOfQuery: 20, commentType: .comment)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var group: Group!
    var cellTypes: [[GroupDetailCellType]] = [[.headerCell], [.queueCell], [.scheduleCell]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "GroupDetailImageHeaderTVCell", bundle: nil), forCellReuseIdentifier: "GroupDetailImageHeaderTVCell")
        tableView.register(UINib.init(nibName: "GroupDetailTextHeaderTVCell", bundle: nil), forCellReuseIdentifier: "GroupDetailTextHeaderTVCell")
        tableView.register(UINib.init(nibName: "GroupDetailQueueTVCell", bundle: nil), forCellReuseIdentifier: "GroupDetailQueueTVCell")
        tableView.register(UINib.init(nibName: "GroupTextInfoTVCell", bundle: nil), forCellReuseIdentifier: "GroupTextInfoTVCell")
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if group.getRequirement() != "" {
            cellTypes[2].append(.requirementCell)
        }
        if group.getDescription() != "" {
            cellTypes[2].append(.descriptionCell)
        }
        if group!.getContact() != "" {
            cellTypes[2].append(.contactCell)
        }
        if group!.getLocation() != "" {
            cellTypes[2].append(.locationCell)
        }
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
    
    func schedulesToString() -> String {
        let schedules = group.getSchedules()
        var scheduleText = ""
        for i in 0..<schedules.count {
            if i != 0 {
                scheduleText.append("\n\n")
            }
            scheduleText.append(schedules[i].toString()!)
        }
        return scheduleText
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension GroupDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.section][indexPath.row] {
        case .headerCell:
            if group.getImage().numOfImages() > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailImageHeaderTVCell") as! GroupDetailImageHeaderTVCell
                cell.updateCell(title: group.getTitle(), departments: group.getDepartments(), professors: group.getProfessors(), imageData: group.getImage())
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailTextHeaderTVCell") as! GroupDetailTextHeaderTVCell
                cell.updateCell(title: group.getTitle(), departments: group.getDepartments(), professors: group.getProfessors())
                return cell
            }
        case .queueCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailQueueTVCell") as! GroupDetailQueueTVCell
            cell.updateCell(maxSlots: group.getMaxSlots(), memberCount: group.getQueueMemberCount(), pendingCount: group.getQueuePendingCount())
            return cell
        case .scheduleCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTextInfoTVCell") as! GroupTextInfoTVCell
            var schedules = group.getSchedules()
            if schedules.count == 0 {
                // download schedules if schedules is empty
                let ref = Database.database().reference()
                ref.child(group.getScheduleList()).observe(.value, with: { (snapshot) in
                    guard snapshot.exists() else {
                        return
                    }
                    if let schedulesData = snapshot.value as? [[String: AnyObject]] {
                        for scheduleData in schedulesData {
                            let schedule = Schedule()
                            schedule.initialize(scheduleData: scheduleData)
                            schedules.append(schedule)
                        }
                        self.group.setSchedules(schedules: schedules)
                        //cell.updateCell(title: "Schedule", text: self.schedulesToString())
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    } else {
                        // Error appears
                    }
                })
            } else {
                print("in")
                cell.updateCell(title: "Schedule", text: self.schedulesToString())
            }
            return cell
        case .requirementCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTextInfoTVCell") as! GroupTextInfoTVCell
            cell.updateCell(title: "Requirement", text: group.getRequirement())
            return cell
        case .descriptionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTextInfoTVCell") as! GroupTextInfoTVCell
            cell.updateCell(title: "Description", text: group.getDescription())
            return cell
        case .locationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTextInfoTVCell") as! GroupTextInfoTVCell
            cell.updateCell(title: "Location", text: group.getLocation())
            return cell
        case .contactCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTextInfoTVCell") as! GroupTextInfoTVCell
            cell.updateCell(title: "Contact Information", text: group!.getContact())
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}


extension GroupDetailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
}

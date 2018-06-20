//
//  GroupMainTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


protocol GroupMainCellDelegate {
    func cellPushed(indexPath: IndexPath)
}



class GroupMainTVC: UITableViewController {
    
    @IBAction func searchIsPushed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    @IBAction func createIsPushed(_ sender: UIButton) {
        if Auth.auth().currentUser == nil{
            let authVC = AuthorizationViewController(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: "CreateGroup", bundle: nil)
            self.present(storyboard.instantiateInitialViewController()!, animated: true, completion: nil)
        }
    }
    
    var dataIsLoaded: Bool = false
    var groups: [[Group]] = [[], [], []]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.tableView.register(UINib.init(nibName: "GroupHeaderTVCell", bundle: nil), forCellReuseIdentifier: "GroupHeaderTVCell")
        self.tableView.register(UINib.init(nibName: "GroupMainImageTVCell", bundle: nil), forCellReuseIdentifier: "GroupMainImageTVCell")
        self.tableView.register(UINib.init(nibName: "GroupMainTextTVCell", bundle: nil), forCellReuseIdentifier: "GroupMainTextTVCell")
        self.tableView.register(UINib.init(nibName: "GroupFooterTVCell", bundle: nil), forCellReuseIdentifier: "GroupFooterTVCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadData() {
        let group = Group(reference: "group_info/-KpT6IowopfnlvLyPceo")
        group.retrieveTinyData()
//        group.retrieveGroupFromDirectory { (snapshot) in
//            if snapshot.exists() {
//                self.groups = [[group, group, group, group],
//                               [group, group, group, group],
//                               [group, group, group, group]]
//                self.dataIsLoaded = true
//                self.tableView.reloadData()
//            } else {
//
//            }
//        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if dataIsLoaded {
            return groups.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataIsLoaded {
            return groups[section].count + 2
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupHeaderTVCell") as! GroupHeaderTVCell
            switch indexPath.section {
            case 0:
                cell.updateCell(image: #imageLiteral(resourceName: "professor_project"), category: "Most Viewed Professors' Projects")
            case 1:
                cell.updateCell(image: #imageLiteral(resourceName: "student_project"), category: "Most Viewed Students' Projects")
            case 2:
                cell.updateCell(image: #imageLiteral(resourceName: "group_activity"), category: "Most Viewed Activities")
            default:
                return UITableViewCell()
            }
            return cell
        case 1, 2, 3, 4:
            let group = groups[indexPath.section][indexPath.row - 1]
            if group.getGroupImage() != nil && group.getGroupImage()!.numOfImages() > 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupMainImageTVCell") as! GroupMainImageTVCell
                cell.updateCell(group: group)
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupMainTextTVCell") as! GroupMainTextTVCell
                cell.updateCell(group: group)
                return cell
            }
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupFooterTVCell") as! GroupFooterTVCell
            switch indexPath.section {
            case 0:
                cell.category.text = "More Professors' Projects"
            case 1:
                cell.category.text = "More Students' Projects"
            case 2:
                cell.category.text = "More Activities"
            default:
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1, 2, 3, 4:
            selectedIndexPath = indexPath
            performSegue(withIdentifier: "toGroupDetail", sender: self)
        case 0, 5:
            selectedIndexPath = nil
            performSegue(withIdentifier: "toMoreGroups", sender: self)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0.1
        }
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "toGroupDetail":
            let vc = segue.destination as! GroupDetailVC
            vc.group = groups[selectedIndexPath!.section][selectedIndexPath!.row - 1]
        case "toMoreGroups":
            let vc = segue.destination as! GroupMoreGroupsTVC
        default:
            break
        }
    }
}


extension GroupMainTVC: GroupMainCellDelegate {
    func cellPushed(indexPath: IndexPath) {
        
    }
}

extension GroupMainTVC: AuthorizationViewControllerDelegate {
    func authorizationViewControllerWillDisappear() {
        
    }
}

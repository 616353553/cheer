//
//  MeMainTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth


private enum MeMainCellType {
    case userInfoCell
    case schoolCell
    case schedulerCell
    case groupCell
    case encyclopediaCell
    case authCell
}

private enum MeMainPrototypeCellType {
    case headerCell
    case imageTextCell
    case textCell
    case basicCell
}

private struct MeMainCellData {
    var cellType: MeMainCellType
    var prototypeCellType: MeMainPrototypeCellType
    var image: UIImage?
    var text: String
}

class MeMainTVC: UITableViewController {

    private var cellsData: [[MeMainCellData]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCellsData()
        
        tableView.register(UINib.init(nibName: "MeHeaderTVCell", bundle: nil), forCellReuseIdentifier: "MeHeaderTVCell")
        tableView.register(UINib.init(nibName: "MeImageTextTVCell", bundle: nil), forCellReuseIdentifier: "MeImageTextTVCell")
        tableView.register(UINib.init(nibName: "MeTextTVCell", bundle: nil), forCellReuseIdentifier: "MeTextTVCell")
        tableView.register(UINib.init(nibName: "MeBasicTVCell", bundle: nil), forCellReuseIdentifier: "MeBasicTVCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateCellsData() {
        cellsData = [[MeMainCellData]]()
        
        cellsData.append([MeMainCellData(cellType: .userInfoCell, prototypeCellType: .headerCell, image: nil, text: "")])
        cellsData.append([MeMainCellData(cellType: .schoolCell, prototypeCellType: .textCell, image: nil, text: CoreDataManagement.getSchool() ?? "")])
        
        if Auth.auth().currentUser != nil {
            cellsData.append([MeMainCellData(cellType: .schedulerCell, prototypeCellType: .imageTextCell, image: #imageLiteral(resourceName: "Calendar"), text: "Scheduler"),
                              MeMainCellData(cellType: .groupCell, prototypeCellType: .imageTextCell, image: #imageLiteral(resourceName: "Group"), text: "Group"),
                              MeMainCellData(cellType: .encyclopediaCell, prototypeCellType: .imageTextCell, image: #imageLiteral(resourceName: "Encyclopedia"), text: "Encyclopedia")])
            cellsData.append([MeMainCellData(cellType: .authCell, prototypeCellType: .basicCell, image: nil, text: "Sign out")])
        } else {
            cellsData.append([MeMainCellData(cellType: .authCell, prototypeCellType: .basicCell, image: nil, text: "Sign in")])
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellsData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cellsData[indexPath.section][indexPath.row]
        switch cellData.prototypeCellType {
        case .headerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHeaderTVCell") as! MeHeaderTVCell
            if let uid = Auth.auth().currentUser?.uid {
                let user = UserProfile()
                user.initialize(uid: uid)
                cell.updateCell(user: user, delegate: self)
            } else {
                cell.updateCell(user: nil, delegate: self)
            }
            return cell
        case .imageTextCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeImageTextTVCell") as! MeImageTextTVCell
            cell.updateCell(guideImage: cellData.image, guideText: cellData.text)
            return cell
        case .textCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeTextTVCell") as! MeTextTVCell
            cell.updateCell(text: cellData.text)
            return cell
        case .basicCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeBasicTVCell") as! MeBasicTVCell
            cell.updateCell(guideText: cellData.text)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = cellsData[indexPath.section][indexPath.row]
        switch cellData.cellType {
        case .userInfoCell:
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "toPersonalInfo", sender: self)
            } else {
                let vc = AuthorizationViewController()
                vc.initialize(authType: .regular, delegate: self)
                vc.presentFromBottom(viewController: self, completion: nil)
            }
        case .schoolCell:
            let vc = ChooseSchoolTableViewController()
            vc.initialize(delegate: self)
            vc.presentOnNavigationController(navigationController: self.navigationController!)
        case .schedulerCell:
            print("schedule")
        case .groupCell:
            print("group")
        case .encyclopediaCell:
            print("encyclopedia")
        case .authCell:
            if Auth.auth().currentUser != nil {
                Alert.displayAlertWithTwoButtons(title: "Alert", message: "Log out of Cheer?", vc: self, handler: { (action) in
                    let spinner = UIActivityIndicatorView()
                    Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        Alert.displayAlertWithOneButton(title: "Error", message: error.localizedDescription, vc: self)
                    }
                    Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
                    self.updateCellsData()
                    self.tableView.reloadData()
                })
            } else {
                let vc = AuthorizationViewController()
                vc.initialize(authType: .regular, delegate: self)
                vc.presentFromBottom(viewController: self, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 10
        }
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

extension MeMainTVC: MeHeaderTVCellDelegate {
    func userIconPushed() {
        
    }
}

extension MeMainTVC: AuthorizationViewControllerDelegate {
    func authorizationViewControllerWillDisappear() {
        updateCellsData()
        tableView.reloadData()
    }
}


extension MeMainTVC: ChooseSchoolTVCDelegate {
    func schoolChoosed(vc: ChooseSchoolTVC) {
        vc.navigationController?.popViewController(animated: true)
        updateCellsData()
        tableView.reloadData()
    }
}

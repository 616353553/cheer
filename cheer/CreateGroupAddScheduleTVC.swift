//
//  CreateGroupAddScheduleTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/6.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupAddScheduleTVC: UITableViewController {

    @IBAction func nextPushed(_ sender: UIBarButtonItem) {
//        if group!.isValidSchedules() {
//            self.performSegue(withIdentifier: "toOptionalInfo", sender: self)
//        } else {
//            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid Schedules", vc: self)
//        }
    }
    
    var group: Group!
    var schedules: [Schedule]!
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //schedules = group!.getSchedules()
        tableView.register(UINib.init(nibName: "CreateGroupScheduleTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupScheduleTVCell")
        tableView.register(UINib.init(nibName: "CreateGroupAddScheduleTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupAddScheduleTVCell")
        
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
        return schedules.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < schedules.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupScheduleTVCell") as! CreateGroupScheduleTVCell
            cell.updateCell(text: schedules[indexPath.row].toColorString(), indexPath: indexPath, delegate: self)
            //cell.updateCell(text: schedules[indexPath.row].toStringArray()!, indexPath: indexPath, delegate: self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupAddScheduleTVCell") as! CreateGroupAddScheduleTVCell
            cell.updateCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: "toScheduleContent", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScheduleContent" {
            let vc = segue.destination as! CreateGroupScheduleContentTVC
            if selectedIndex!.row < schedules.count {
                let schedule = schedules[selectedIndex!.row]
                vc.schedule = schedule.copy()
            } else {
                vc.schedule = Schedule()
                vc.schedule.initialize()
            }
            vc.delegate = self
        } else if segue.identifier == "toOptionalInfo" {
            let vc = segue.destination as! CreateGroupOptionalInfoTVC
            vc.group = self.group
        }
    }
}

extension CreateGroupAddScheduleTVC: CreateGroupScheduleTVCellDelegate {
    func deleteButtonPushed(indexPath: IndexPath) {
//        schedules.remove(at: indexPath.row)
//        group!.setSchedules(schedules: schedules)
//        tableView.deleteRows(at: [indexPath], with: .none)
//        tableView.reloadData()
    }
}

extension CreateGroupAddScheduleTVC: CreateGroupScheduleContentTVCDelegate {
    func scheduleCreated(schedule: Schedule) {
//        if selectedIndex!.row == schedules.count {
//            schedules.append(schedule)
//        } else {
//            schedules[selectedIndex!.row] = schedule
//        }
//        group!.setSchedules(schedules: schedules)
//        tableView.reloadData()
    }
}

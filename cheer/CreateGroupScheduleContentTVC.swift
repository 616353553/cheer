//
//  CreateGroupScheduleContentTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

enum ScheduleCellType {
    case repeatSwitchCell
    case dateCell
    case datePickerCell
    case repeatTypeCell
    case frequencyCell
    case frequencyPickerCell
    case startDateCell
    case startDatePickerCell
    case endDateCell
    case endDatePickerCell
    case wholeDaySwitchCell
    case startTimeCell
    case startTimePickerCell
    case endTimeCell
    case endTimePickerCell
}

protocol CreateGroupScheduleContentTVCDelegate {
    func scheduleCreated(schedule: Schedule)
}

class CreateGroupScheduleContentTVC: UITableViewController {
    
    @IBAction func donePushed(_ sender: UIBarButtonItem) {
        if schedule!.isValidSchedule() == nil {
            delegate!.scheduleCreated(schedule: schedule!)
            self.navigationController?.popViewController(animated: true)
        } else {
            Alert.displayAlertWithOneButton(title: "Error", message: schedule!.isValidSchedule()!, vc: self)
        }
    }
    
    var schedule: Schedule!
    var delegate: CreateGroupScheduleContentTVCDelegate?
    
    var cells: [[ScheduleCellType]] = [[], []]
    var dateCells: [[ScheduleCellType]] = [[.repeatSwitchCell, .repeatTypeCell, .frequencyCell, .startDateCell, .endDateCell],
                                           [.repeatSwitchCell, .dateCell]]
    var timeCells: [[ScheduleCellType]] = [[.wholeDaySwitchCell],
                                           [.wholeDaySwitchCell, .startTimeCell, .endTimeCell]]
    
    var currentPickerCell: ScheduleCellType?
    
    lazy var repeatByDayData: [[String]] = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"]]
    
    lazy var repeatByWeekData: [[String]] = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"], ["Sunday", "Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday"]]
    
    lazy var repeatByMonthData: [[String]] = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
                                              ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th", "21st", "22nd", "23rd", "24th", "25th", "26th", "27th", "28th", "29th", "30th", "31st", "last"],
                                              ["day", "Sunday", "Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if schedule!.getRepeating()! {
            cells[0] = dateCells[0]
        } else {
            cells[0] = dateCells[1]
        }
        if schedule!.getWholeDay()! {
            cells[1] = timeCells[0]
        } else {
            cells[1] = timeCells[1]
        }
        
        tableView.register(UINib.init(nibName: "CreateGroupSwitchTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupSwitchTVCell")
        tableView.register(UINib.init(nibName: "CreateGroupRepeatTypeTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupRepeatTypeTVCell")
        tableView.register(UINib.init(nibName: "CreateGroupPickerHeaderCell", bundle: nil), forCellReuseIdentifier: "CreateGroupPickerHeaderCell")
        tableView.register(UINib.init(nibName: "CreateGroupDatePickerTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupDatePickerTVCell")
        tableView.register(UINib.init(nibName: "CreateGroupPickerTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupPickerTVCell")
        
        //tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "Back_Chevron"), for: .normal)
        backButton.setTitleColor(Config.themeColor, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleEdgeInsets.left = 8
        backButton.contentEdgeInsets.left = -16
        backButton.frame = CGRect.init(x: 0, y: 0, width: 52, height: 30)
        backButton.addTarget(self, action: #selector(backPushed(_:)), for: .touchUpInside)
        navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: backButton)], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func backPushed(_ sender: UIBarButtonItem) {
        Alert.displayAlertWithTwoButtons(title: "Alert", message: "Performing this action will discard all the changes you have made", vc: self) { (alert) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func removeCurrentPickerCell() {
        if currentPickerCell == nil {
            return
        }
        switch currentPickerCell! {
        case .datePickerCell, .frequencyPickerCell, .startDatePickerCell, .endDatePickerCell:
            if let index = cells[0].index(of: currentPickerCell!) {
                cells[0].remove(at: index)
            }
        case .startTimePickerCell, .endTimePickerCell:
            if let index = cells[1].index(of: currentPickerCell!) {
                cells[1].remove(at: index)
            }
        default:
            break
        }
        currentPickerCell = nil
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.section][indexPath.row]
        switch cellType {
        case .repeatTypeCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupRepeatTypeTVCell") as! CreateGroupRepeatTypeTVCell
            cell.updateCell(label: "Repeat by", repeatType: schedule!.getRepeatType())
            return cell
        case .repeatSwitchCell, .wholeDaySwitchCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupSwitchTVCell") as! CreateGroupSwitchTVCell
            var labelText: String!
            var isOn: Bool!
            switch cellType {
            case .repeatSwitchCell:
                labelText = "Repeat"
                isOn = schedule!.getRepeating()!
            case .wholeDaySwitchCell:
                labelText = "Whole day"
                isOn = schedule!.getWholeDay()!
            default:
                break
            }
            cell.updateCell(label: labelText, isOn: isOn, indexPath: indexPath, delegate: self)
            return cell
        case .frequencyCell, .dateCell, .startDateCell, .endDateCell, .startTimeCell, .endTimeCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupPickerHeaderCell") as! CreateGroupPickerHeaderCell
            var labelText : String!
            var result: String!
            var isValid: Bool!
            switch cellType {
            case .frequencyCell:
                if schedule!.getFrequency() == nil {
                    switch schedule!.getRepeatType()! {
                    case .repeatByDay:
                        schedule!.setFrequency(frequency: ["1"])
                    case .repeatByWeek:
                        schedule!.setFrequency(frequency: ["1", "Sunday"])
                    case .repeatByMonth:
                        schedule!.setFrequency(frequency: ["1", "1st", "day"])
                    }
                }
                labelText = "For"
                result = schedule!.frequencyToString()!
                isValid = true
            case .dateCell:
                labelText = "On"
                result = schedule!.dateToString()!
                isValid = true
            case .startDateCell:
                labelText = "Start repeat on"
                result = schedule!.startDateToString()!
                isValid = schedule!.isValidDates()
            case .endDateCell:
                labelText = "End repeat on"
                result = schedule!.endDateToString()!
                isValid = schedule!.isValidDates()
            case .startTimeCell:
                labelText = "Start time"
                result = schedule!.startTimeToString()!
                isValid = schedule!.isValidTimes()
            case .endTimeCell:
                labelText = "End time"
                result = schedule!.endTimeToString()!
                isValid = schedule!.isValidTimes()
            default:
                break
            }
            cell.updateCell(labelText: labelText, result: result, isValid: isValid, indexPath: indexPath)
            return cell
        case .frequencyPickerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupPickerTVCell") as! CreateGroupPickerTVCell
            var data: [[String]]!
            switch schedule.getRepeatType()! {
            case .repeatByDay:
                data = repeatByDayData
            case .repeatByWeek:
                data = repeatByWeekData
            case .repeatByMonth:
                data = repeatByMonthData
            }
            cell.updateCell(data: data, frequency: schedule!.getFrequency(), indexPath: indexPath, delegate: self)
            return cell
        case .datePickerCell, .startDatePickerCell, .endDatePickerCell, .startTimePickerCell, .endTimePickerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupDatePickerTVCell") as! CreateGroupDatePickerTVCell
            var date: Date!
            var pickerMode: UIDatePickerMode!
            switch cellType  {
            case .datePickerCell:
                date = schedule!.getDate()
                pickerMode = .date
            case .startDatePickerCell:
                date = schedule!.getStartDate()
                pickerMode = .date
            case .endDatePickerCell:
                date = schedule!.getEndDate()
                pickerMode = .date
            case .startTimePickerCell:
                date = schedule!.getStartTime()
                pickerMode = .time
            case .endTimePickerCell:
                date = schedule!.getEndTime()
                pickerMode = .time
            default:
                break
            }
            cell.updateCell(date: date, pickerMode: pickerMode, indexPath: indexPath, delegate: self)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cells[indexPath.section][indexPath.row]
        switch cellType {
        case .datePickerCell, .frequencyPickerCell, .startDatePickerCell, .endDatePickerCell, .startTimePickerCell, .endTimePickerCell:
            return 216
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.section][indexPath.row]
        var pickerCellType: ScheduleCellType?
        switch cellType {
        case .dateCell:
            pickerCellType = .datePickerCell
        case .startDateCell:
            pickerCellType = .startDatePickerCell
        case .endDateCell:
            pickerCellType = .endDatePickerCell
        case .startTimeCell:
            pickerCellType = .startTimePickerCell
        case .endTimeCell:
            pickerCellType = .endTimePickerCell
        case .frequencyCell:
            pickerCellType = .frequencyPickerCell
        case .repeatTypeCell:
            self.performSegue(withIdentifier: "toScheduleType", sender: self)
            return
        default:
            return
        }
        if currentPickerCell != nil {
            if pickerCellType != currentPickerCell {
                cells[indexPath.section].insert(pickerCellType!, at: indexPath.row + 1)
                removeCurrentPickerCell()
                currentPickerCell = pickerCellType
            } else {
                removeCurrentPickerCell()
            }
        } else {
            currentPickerCell = pickerCellType
            cells[indexPath.section].insert(pickerCellType!, at: indexPath.row + 1)
        }
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScheduleType" {
            let vc = segue.destination as! CreateGroupScheduleTypeTVC
            vc.repeatType = schedule!.getRepeatType()!
            vc.delegate = self
        }
    }

}

extension CreateGroupScheduleContentTVC: CreateGroupSwitchTVCellDelegate {
    func switchChanged(isOn: Bool, indexPath: IndexPath) {
        let cellType = cells[indexPath.section][indexPath.row]
        switch cellType {
        case .repeatSwitchCell:
            schedule!.setRepeating(repeating: isOn)
            if isOn {
                cells[0] = dateCells[0]
            } else {
                cells[0] = dateCells[1]
            }
        case .wholeDaySwitchCell:
            schedule!.setWholeDay(wholeDay: isOn)
            if isOn {
                cells[1] = timeCells[0]
            } else {
                cells[1] = timeCells[1]
            }
        default:
            break
        }
        tableView.reloadData()
    }
}

extension CreateGroupScheduleContentTVC: CreateGroupDatePickerTVCellDelegate{
    func dateChanged(date: Date, indexPath: IndexPath) {
        let cellType = cells[indexPath.section][indexPath.row]
        let cell = tableView.cellForRow(at: [indexPath.section, indexPath.row - 1]) as! CreateGroupPickerHeaderCell
        switch cellType {
        case .datePickerCell:
            schedule!.setDate(date: date)
            cell.setResutLabel(text: schedule!.dateToString()!, isValid: true)
        case .startDatePickerCell:
            schedule!.setStartDate(startDate: date)
            tableView.reloadSections([0], with: .none)
        case .endDatePickerCell:
            schedule!.setEndDate(endDate: date)
            tableView.reloadSections([0], with: .none)
        case .startTimePickerCell:
            schedule!.setStartTime(startTime: date)
            tableView.reloadSections([1], with: .none)
        case .endTimePickerCell:
            schedule!.setEndTime(endTime: date)
            tableView.reloadSections([1], with: .none)
        default:
            break
        }
    }
}

extension CreateGroupScheduleContentTVC: CreateGroupPickerTVCellDelegate {
    func pickerChanged(indexPath: IndexPath, frequency: [String]) {
        let cellType = cells[indexPath.section][indexPath.row]
        let cell = tableView.cellForRow(at: [indexPath.section, indexPath.row - 1]) as! CreateGroupPickerHeaderCell
        switch cellType {
        case .frequencyPickerCell:
            schedule!.setFrequency(frequency: frequency)
            cell.setResutLabel(text: schedule!.frequencyToString()!, isValid: true)
        default:
            break
        }
    }
}

extension CreateGroupScheduleContentTVC: CreateGroupScheduleTypeTVCDelegate {
    func typeSelected(newType: ScheduleRepeatingType) {
        if newType != schedule!.getRepeatType()! {
            schedule!.setRepeatType(repeatType: newType)
            schedule!.setFrequency(frequency: nil)
            if currentPickerCell == .frequencyPickerCell {
                removeCurrentPickerCell()
            }
            tableView.reloadSections([0], with: .none)
        }
    }
}

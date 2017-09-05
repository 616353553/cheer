//
//  ReportMainTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class ReportMainTVC: UITableViewController {
    
    @IBAction func cancelPushed(_ sender: UIBarButtonItem) {
        Alert.displayAlertWithTwoButtons(title: "Alert", message: "Performing this action will discard all the changes you have made", vc: self) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func submitPushed(_ sender: UIBarButtonItem) {
        var reasonStrings = [String?](repeating: nil, count: reasons.count)
        for i in 0..<isSelected.count {
            if isSelected[i] {
                reasonStrings[i] = reasonString[i]
            }
        }
        report.setReasons(reasons: reasonStrings)
        if report.isValidReport() == nil {
            report.upload(completion: { (errorString, snapshot) in
                if errorString != nil {
                    Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
                } else {
                    Alert.displayAlertWithOneButton(title: "Submitted", message: "A report has been sent to the tribunal for review. Thank you", vc: self, alertActionHandler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        } else {
            Alert.displayAlertWithOneButton(title: "Error", message: report.isValidReport()!, vc: self)
        }
    }
    
    private var reasons: [String: String]!
    private var reasonString = [String]()
    private var descriptionString = [String]()
    private var isSelected: [Bool]!
    fileprivate var report: Report!
    private var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let reportNVC = self.parent as? ReportNVC {
            report = reportNVC.report
            reasons = reportNVC.reasons
        }
        for reason in reasons {
            reasonString.append(reason.key)
            descriptionString.append(reason.value)
        }
        isSelected = [Bool](repeating: false, count: reasons.count)
        tableView.register(UINib(nibName: "ReportReasonTVCell", bundle: nil), forCellReuseIdentifier: "ReportReasonTVCell")
        tableView.register(UINib(nibName: "ReportDescriptionTVCell", bundle: nil), forCellReuseIdentifier: "ReportDescriptionTVCell")
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification){
        self.view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification){
        self.view.removeGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard(){
        self.view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return reasons.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Report reason"
        case 1:
            return "Additional Comments (optional)"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        header.textLabel?.frame = header.frame
        switch section {
        case 0:
            header.textLabel?.text = "Report reason"
        case 1:
            header.textLabel?.text = "Additional Comments (optional)"
        default:
            break
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportReasonTVCell") as! ReportReasonTVCell
            cell.updateCell(reason: reasonString[indexPath.row], description: descriptionString[indexPath.row], isSelected: isSelected[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDescriptionTVCell") as! ReportDescriptionTVCell
            cell.updateCell(description: report.getDescription(), delegate: self)
            return cell
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let reasonCell = tableView.cellForRow(at: indexPath) as? ReportReasonTVCell {
            isSelected[indexPath.row] = !isSelected[indexPath.row]
            reasonCell.setSelected(isSelected: isSelected[indexPath.row])
        }
    }
}

extension ReportMainTVC: ReportDescriptionTVCellDelegate {
    func textChanged(text: String) {
        report.setDescription(description: text)
    }
}

//
//  CreateGroupAddProfessorTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupAddProfessorTVC: UITableViewController {

    @IBAction func nextPushed(_ sender: UIBarButtonItem) {
        if group!.isValidProfessors() {
            group.setProfessors(professors: professors)
            self.performSegue(withIdentifier: "toDepartments", sender: self)
        } else {
            Alert.displayAlertWithOneButton(title: "Error", message: "Must have at least 1 professor", vc: self)
        }
    }
    
    var group: Group!
    var professors: [String?]!
    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "AddProfessorDepartmentTVCell", bundle: nil), forCellReuseIdentifier: "AddProfessorDepartmentTVCell")
        tableView.tableFooterView = UIView()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.addGestureRecognizer(tap)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.removeGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfessorDepartmentTVCell") as! AddProfessorDepartmentTVCell
        if indexPath.row + 1 == professors.count && professors.count < Config.maxProfessors {
            cell.updateCell(indexPath: indexPath, placeholder: "Enter professor name here", input: professors[indexPath.row], delegate: self, buttonAction: .addCell)
        } else {
            cell.updateCell(indexPath: indexPath, placeholder: "Enter professor name here", input: professors[indexPath.row], delegate: self, buttonAction: .removeCell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDepartments" {
            let vc = segue.destination as! CreateGroupAddDepartmentTVC
            vc.group = self.group
            vc.departments = group!.getDepartments()
        }
    }
}

extension CreateGroupAddProfessorTVC: AddProfessorDepartmentTVCellDelegate {
    func buttonIsPushed(indexPath: IndexPath, action: ButtonAction) {
        tableView.beginUpdates()
        switch action {
        case .addCell:
            professors.append(nil)
            tableView.insertRows(at: [[0, indexPath.row + 1]], with: .automatic)
        case .removeCell:
            professors.remove(at: indexPath.row)
            tableView.deleteRows(at: [[0, indexPath.row]], with: .none)
        }
        group!.setProfessors(professors: professors)
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    func textFieldChanged(indexPath: IndexPath, text: String?) {
        professors[indexPath.row] = text
        group!.setProfessors(professors: professors)
    }
}

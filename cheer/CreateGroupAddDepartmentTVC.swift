//
//  CreateGroupAddDepartmentTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/6.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupAddDepartmentTVC: UITableViewController {

    @IBAction func nextPushed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toSchedules", sender: self)
    }
    
    var group: Group!
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
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSchedules" {
            let vc = segue.destination as! CreateGroupAddScheduleTVC
            vc.group = self.group
        }
    }

}

extension CreateGroupAddDepartmentTVC: AddProfessorDepartmentTVCellDelegate {
    func buttonIsPushed(indexPath: IndexPath, action: ButtonAction) {
//        tableView.beginUpdates()
//        switch action {
//        case .addCell:
//            group.getDepartments().append(department: nil)
//            tableView.insertRows(at: [[0, indexPath.row + 1]], with: .automatic)
//        case .removeCell:
//            group.getDepartments().remove(at: indexPath.row)
//            tableView.deleteRows(at: [[0, indexPath.row]], with: .none)
//        }
//        tableView.endUpdates()
//        tableView.reloadData()
    }
    
    func textFieldChanged(indexPath: IndexPath, text: String?) {
        //group.getDepartments().set(at: indexPath.row, department: text)
    }
}

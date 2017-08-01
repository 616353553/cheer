//
//  CreateGroupOptionalInfoTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/12.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import Photos
import  BSImagePicker

class CreateGroupOptionalInfoTVC: UITableViewController {

    @IBAction func nextPushed(_ sender: UIBarButtonItem) {
        if group!.isValidGroup() {
            self.performSegue(withIdentifier: "toRules", sender: self)
        } else {
            Alert.displayAlertWithOneButton(title: "Error", message: "Unknown error, please try again later", vc: self)
        }
    }
    
    var group: Group!
    var textViewCellsStates: [CellState] = [.contracted, .contracted, .contracted, .contracted]
    var tap: UITapGestureRecognizer!
    var imagePicker: BSImagePickerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "CreateGroupImageTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupImageTVCell")
        self.tableView.register(UINib.init(nibName: "CreateGroupTextViewTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupTextViewTVCell")
        self.tableView.register(UINib.init(nibName: "CreateGroupSlotsTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupSlotsTVCell")
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0, 0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupImageTVCell") as! CreateGroupImageTVCell
            cell.updateCell(image: group!.getImage().getImage(atIndex: 0), indexPath: indexPath, delegate: self)
            return cell
        case [1 , 0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupSlotsTVCell") as! CreateGroupSlotsTVCell
            cell.updateCell(maxSlots: group!.getMaxSlots(), minAllowed: Config.minMembersAllowed, maxAllowed: Config.maxMembersAllowed, indexPath: indexPath, delegate: self)
            return cell
        case [2, 0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTextViewTVCell") as! CreateGroupTextViewTVCell
            cell.updateCell(label: "Location", text: group!.getLocation(), placeHolder: "Enter location here", indexPath: indexPath, delegate: self)
            return cell
        case [2, 1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTextViewTVCell") as! CreateGroupTextViewTVCell
            cell.updateCell(label: "Contact information", text: group!.getContact(), placeHolder: "Enter contact here", indexPath: indexPath, delegate: self)
            return cell
        case [2, 2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTextViewTVCell") as! CreateGroupTextViewTVCell
            cell.updateCell(label: "Requirement", text: group!.getRequirement(), placeHolder: "Enter requirment here", indexPath: indexPath, delegate: self)
            return cell
        case [2, 3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTextViewTVCell") as! CreateGroupTextViewTVCell
            cell.updateCell(label: "Description", text: group!.getDescription(), placeHolder: "Enter description here", indexPath: indexPath, delegate: self)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case [0, 0]:
            return 300
        case [1, 0]:
            return 306
        case [2, 0], [2, 1], [2, 2], [2, 3]:
            switch textViewCellsStates[indexPath.row] {
            case .contracted:
                return 44
            case .expanded:
                return 300
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            for i in 0..<textViewCellsStates.count {
                if indexPath.row == i {
                    switch textViewCellsStates[i] {
                    case .contracted:
                        textViewCellsStates[i] = .expanded
                    case .expanded:
                        textViewCellsStates[i] = .contracted
                    }
                } else {
                    textViewCellsStates[i] = .contracted
                }
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! CreateGroupTextViewTVCell
            tableView.beginUpdates()
            tableView.endUpdates()
            cell.rotateArrow(cellState: textViewCellsStates[indexPath.row])
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRules" {
            let vc = segue.destination as! CreateGroupRulesTVC
            vc.group = self.group
        }
    }
}

extension CreateGroupOptionalInfoTVC: CreateGroupTextViewTVCellDelegate {
    func textChanged(text: String, indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            group!.setLocation(location: text)
        case 1:
            group!.setContact(contact: text)
        case 2:
            group!.setRequirement(requirment: text)
        case 3:
            group!.setDescription(description: text)
        default:
            break
        }
    }
}

extension CreateGroupOptionalInfoTVC: CreateGroupSlotsTVCellDelegate {
    func maxSlotsChanged(value: Int) {
        group!.setMaxSlots(maxSlots: value)
    }
}

extension CreateGroupOptionalInfoTVC: CreateGroupImageTVCellDelegate {
    func imageChanged(image: UIImage?) {
        self.group.getImage().setImage(atIndex: 0, image: image)
        self.group.getImage().setImage(atIndex: 1, image: image)
    }
    
    func editImage(indexPath: IndexPath) {
        imagePicker = BSImagePickerViewController()
        imagePicker!.maxNumberOfSelections = 1
        bs_presentImagePickerController(imagePicker!, animated: true, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
            self.group.getImage().setImage(atIndex: 0, asset: assets[0], completion: { (image) in
                if image != nil {
                    self.group.getImage().setImage(atIndex: 1, image: image!)
                    let cell = self.tableView.cellForRow(at: indexPath) as! CreateGroupImageTVCell
                    cell.setImage(image: image)
                } else {
                    Alert.displayAlertWithOneButton(title: "Unknown Error", message: "Image cannot be set", vc: self)
                }
            })
        }, completion: nil)
    }
}

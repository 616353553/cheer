//
//  PostTableVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/22.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class PostTableVC: UITableViewController {
    
    var tap: UITapGestureRecognizer!
    
    enum cellTypes {
        case EditableTextViewCell
        case TextFieldCell
        case CollectionViewCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "EditableTextViewCell", bundle: nil), forCellReuseIdentifier: "EditableTextViewCell")
        tableView.register(UINib.init(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellReuseIdentifier: "CollectionViewCell")
        
        
        tap = UITapGestureRecognizer(target: self, action: #selector(PostItemTableVC.dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(PostTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier{
            switch identifier {
            case "EditableTextViewCell":
                let cell = tableView.cellForRow(at: indexPath) as! EditableTextViewCell
                cell.cellIsTouched()
            case "TextFieldCell":
                let cell = tableView.cellForRow(at: indexPath) as! TextFieldCell
                cell.cellIsTouched()
            default:
                break
            }
        }
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
    
    func dequeCell(withType type: cellTypes)->UITableViewCell?{
        switch type {
        case .EditableTextViewCell:
            return tableView.dequeueReusableCell(withIdentifier: "EditableTextViewCell")
        case .TextFieldCell:
            return tableView.dequeueReusableCell(withIdentifier: "TextFieldCell")
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CollectionViewCell")
        }
    }
    
}

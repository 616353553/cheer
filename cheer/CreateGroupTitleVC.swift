//
//  CreateGroupTitleVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupTitleVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textCounterLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func nextPushed(_ sender: UIBarButtonItem) {
        // remove "\n" if there is any
        let title = textView.text.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression, range: nil)
        group.setTitle(title: title)
        if group!.isValidTitle() {
            switch group!.getGroupType() {
            case .professorProject:
                self.performSegue(withIdentifier: "toProfessors", sender: self)
            case .studentProject, .activity:
                self.performSegue(withIdentifier: "toSchedules", sender: self)
            }
        } else {
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid title", vc: self)
        }
    }
    
    var group: Group!
    var tap: UITapGestureRecognizer!
    let minTextViewHeight: CGFloat = 150
    var maxCompressedTextViewHeight: CGFloat?
    var maxExpandedTextViewHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = group.getTitle()
        placeHolderLabel.isHidden = textView.text != nil && textView.text != ""
        textCounterLabel.text = "\(textView.text.characters.count)/\(Config.groupTitleLength) Letters"
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.addGestureRecognizer(tap)
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardFrame = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        maxCompressedTextViewHeight = UIScreen.main.bounds.height - 50 - navigationController!.navigationBar.frame.height - keyboardRectangle.height
        maxExpandedTextViewHeight = UIScreen.main.bounds.height - 50 - navigationController!.navigationBar.frame.height
        
        UIView.animate(withDuration: 0.5) {
            self.bottomConstraint.constant = keyboardRectangle.height + 12
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.removeGestureRecognizer(tap)
        UIView.animate(withDuration: 0.5) {
            self.bottomConstraint.constant = 12
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "toProfessors" {
            let vc = segue.destination as! CreateGroupAddProfessorTVC
            vc.group = self.group
        } else if segue.identifier == "toSchedules" {
            let vc = segue.destination as! CreateGroupAddScheduleTVC
            vc.group = self.group
        }
    }
}


extension CreateGroupTitleVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        group!.setTitle(title: textView.text!)
        placeHolderLabel.isHidden = textView.text != ""
        textCounterLabel.textColor = textView.text.characters.count > Config.groupTitleLength ? UIColor.red : UIColor.darkGray 
        textCounterLabel.text = "\(textView.text.characters.count)/\(Config.groupTitleLength) Letters"
        let newSize = textView.sizeThatFits(CGSize.init(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height != textView.frame.height {
            if newSize.height > minTextViewHeight && textView.frame.height < maxCompressedTextViewHeight! {
                self.textViewHeightConstraint.constant = newSize.height
                self.view.layoutIfNeeded()
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.frame.height > maxCompressedTextViewHeight! {
            UIView.animate(withDuration: 0.2) {
                self.textViewHeightConstraint.constant = self.maxCompressedTextViewHeight!
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize.init(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height != textView.frame.height {
            if newSize.height > minTextViewHeight {
                if newSize.height < maxExpandedTextViewHeight!{
                    UIView.animate(withDuration: 0.2) {
                        self.textViewHeightConstraint.constant = newSize.height
                        self.view.layoutIfNeeded()
                    }
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.textViewHeightConstraint.constant = self.maxExpandedTextViewHeight!
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

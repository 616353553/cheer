//
//  WelcomeResetPasswordTableVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/3/24.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeResetPasswordTableVC: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValid: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var tap: UITapGestureRecognizer!
    let spinner = UIActivityIndicatorView()
    var timer: Timer?
    var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        // set up observers
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeResetPasswordTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeResetPasswordTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // set up gesture recognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(WelcomeResetPasswordTableVC.dismissKeyboard))
        // send button round corner
        sendButton.layer.cornerRadius = 20
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        sendButton.titleLabel?.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        // sign in button round corner
        signInButton.layer.cornerRadius = 20
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        signInButton.titleLabel?.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil && timer!.isValid{
            timer!.invalidate()
        }
        self.view.endEditing(true)
    }
    
    @IBAction func sendIsPushed(_ sender: UIButton) {
        if timerCount <= 0{
            if emailValid.image == #imageLiteral(resourceName: "Ok_fill"){
                Authorization.resetPassword(email: emailTextField.text!, vc: self) { (error) in
                    if error != nil{
                        self.timerCount = 0
                        self.setSendButton()
                    } else {
                        self.timerCount = 60
                        self.setSendButton()
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setSendButton), userInfo: nil, repeats: true)
                    }
                }
            } else {
                Alert.displayAlertWithOneButton(title: "Error", message: "Invalid email format", vc: self)
            }
        }
    }
    
    func setSendButton(){
        if timerCount <= 0{
            sendButton.setTitle("Send", for: .normal)
            if timer != nil && timer!.isValid{
                timer!.invalidate()
            }
        }
        else{
            sendButton.setTitle("Send(\(timerCount))", for: .normal)
        }
        timerCount = timerCount - 1
    }
    
    func textDidChange(_ textField: UITextField){
        emailValid.image = InputChecker.isValidEmail(text: emailTextField.text!) ? #imageLiteral(resourceName: "Ok_fill") : #imageLiteral(resourceName: "Ok")
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 90
        case 1:
            return 44
        case 2:
            let top = (self.navigationController == nil) ? UIApplication.shared.statusBarFrame.height : self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
            return UIScreen.main.bounds.height - CGFloat(134) - top
        default:
            return 0
        }
    }
}

extension WelcomeResetPasswordTableVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

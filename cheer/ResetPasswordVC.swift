//
//  ResetPasswordVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/20.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {
    
    private var tap: UITapGestureRecognizer!
    private var timer: Timer?
    private var timerCount = 0
    private var spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendIsPushed(_ sender: UIButton) {
        if timerCount <= 0{
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!){ (error) in
                Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                if error != nil{
                    self.timerCount = 0
                    self.setSendButton()
                    Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: self)
                } else {
                    self.timerCount = 60
                    self.setSendButton()
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setSendButton), userInfo: nil, repeats: true)
                    Alert.displayAlertWithOneButton(title: "Success", message: "Please check your email", vc: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        sendButton.layer.cornerRadius = 20
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
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
    
    func setSendButton(){
        if timerCount <= 0{
            sendButton.setTitle("Send", for: .normal)
            if timer != nil && timer!.isValid{
                timer!.invalidate()
            }
        } else {
            sendButton.setTitle("Send(\(timerCount))", for: .normal)
        }
        timerCount = timerCount - 1
    }
    
    
    
    //Handle keyboard actions
    func keyboardWillShow(notification: NSNotification){
        self.view.addGestureRecognizer(tap)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.removeGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension ResetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

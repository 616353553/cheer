//
//  SignUpTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

private enum SignUpValidType {
    case email
    case password
    case passwordLength
    case passwordContent
    case passwordSpecial
}

class SignUpTVC: UITableViewController {

    // textfields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // "check symbol" images
    @IBOutlet weak var emailValid: UIImageView!
    @IBOutlet weak var passwordValid: UIImageView!
    @IBOutlet weak var passwordValidLength: UIImageView!
    @IBOutlet weak var passwordValidContent: UIImageView!
    @IBOutlet weak var passwordValidSpecial: UIImageView!
    
    // sign up button
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpIsPushed(_ sender: Any) {
        if !isValidEmail {
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid email", vc: self)
        } else if !isValidPassword {
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid password", vc: self)
        } else {
            Authorization.signUp(email: emailTextField.text!, password: passwordTextField.text!, vc: self){ (user, error) in
                if user != nil{
                    switch self.authType! {
                    case AuthType.regular:
                        self.dismiss(animated: true) {
                            self.authorizationViewControllerDelegate.authorizationViewControllerWillDisappear()
                        }
                    case AuthType.firstTime:
                        let vc = ChooseSchoolTableViewController()
                        vc.initialize(delegate: self)
                        vc.presentOnNavigationController(navigationController: self.navigationController!)
                    }
                }
            }
        }
    }
    
    var isEditingPassword = false
    var tap: UITapGestureRecognizer!
    var authType: AuthType!
    var authorizationViewControllerDelegate: AuthorizationViewControllerDelegate!
    
    var isValidEmail: Bool! = false
    var isValidPassword: Bool! = false
    var isValidPasswordLength: Bool! = false
    var isValidPasswordContent: Bool! = false
    var isValidPasswordSepcial: Bool! = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonDesign.round(button: signUpButton, color: Config.themeColor, radius: 20, borderWidth: 1)
        
        // set up delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        // set up observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // set up gesture recognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    func textDidChange(_ textField: UITextField){
        switch textField.restorationIdentifier! {
        case "email":
            setValid(type: .email, value: InputChecker.isValidEmail(text: emailTextField.text!))
        case "password":
            setValid(type: .passwordLength, value: InputChecker.hasCorrectLength(min: 6, max: 16, text: passwordTextField.text!))
            setValid(type: .passwordContent, value: InputChecker.hasValidPasswordContent(text: passwordTextField.text!))
            setValid(type: .passwordSpecial, value: InputChecker.hasNoSpecialLetters(text: passwordTextField.text!))
            setValid(type: .password, value: isValidPasswordLength && isValidPasswordContent && isValidPasswordSepcial)
        default:
            break
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
    
    fileprivate func setValid(type: SignUpValidType, value: Bool) {
        switch type {
        case .email:
            isValidEmail = value
            emailValid.image = value ? #imageLiteral(resourceName: "valid_darkGray_fill") : #imageLiteral(resourceName: "valid_lightGray")
        case .password:
            isValidPassword = value
            passwordValid.image = value ? #imageLiteral(resourceName: "valid_darkGray_fill") : #imageLiteral(resourceName: "valid_lightGray")
        case .passwordLength:
            isValidPasswordLength = value
            passwordValidLength.image = value ? #imageLiteral(resourceName: "valid_darkGray_fill") : #imageLiteral(resourceName: "valid_lightGray")
        case .passwordContent:
            isValidPasswordContent = value
            passwordValidContent.image = value ? #imageLiteral(resourceName: "valid_darkGray_fill") : #imageLiteral(resourceName: "valid_lightGray")
        case .passwordSpecial:
            isValidPasswordSepcial = value
            passwordValidSpecial.image = value ? #imageLiteral(resourceName: "valid_darkGray_fill") : #imageLiteral(resourceName: "valid_lightGray")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        case 1, 2:
            return 44
        case 3:
            return self.isEditingPassword ? 85 : 0
        case 4:
            let top = (self.navigationController == nil) ? UIApplication.shared.statusBarFrame.height : self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
            let short = UIScreen.main.bounds.height - CGFloat(100 + 44 * 2 + 85) - top
            let long = UIScreen.main.bounds.height - CGFloat(100 + 44 * 2) - top
            return isEditingPassword ? short : long
        default:
            return 0
        }
    }
}

extension SignUpTVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingPassword = textField.restorationIdentifier! == "password"
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.restorationIdentifier! == "password"{
            isEditingPassword = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension SignUpTVC: ChooseSchoolTVCDelegate {
    func schoolChoosed(vc: ChooseSchoolTVC) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateInitialViewController()
        self.present(mainVC!, animated: false) {
            self.authorizationViewControllerDelegate.authorizationViewControllerWillDisappear()
        }
    }
}

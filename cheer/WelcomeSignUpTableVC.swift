//
//  WelcomeSignUpTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeSignUpTableVC: UITableViewController {
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
    
    var isEditingPassword = false
    let spinner = UIActivityIndicatorView()
    var tap: UITapGestureRecognizer!
    //var emailChecker = PFUser.query()!
    //var user = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextfield()
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = Config.themeColor.cgColor
        signUpButton.titleLabel?.textColor = Config.themeColor
        // set up observers
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeSignUpTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeSignUpTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // set up gesture recognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(WelcomeSignUpTableVC.dismissKeyboard))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //emailChecker.cancel()
        self.view.endEditing(true)
    }
    
    @IBAction func signUpIsPushed(_ sender: UIButton) {
        if emailValid.image! == #imageLiteral(resourceName: "Ok"){
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid email", vc: self)
        }
        else if passwordValid.image! == #imageLiteral(resourceName: "Ok"){
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid password", vc: self)
        }
        else{
            //print(FIRAuth.auth()!.currentUser?.email ?? "none")
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            FIRAuth.auth()!.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if user != nil{
                    user!.sendEmailVerification(completion: {(error) in
                        Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                        self.performSegue(withIdentifier: "selectSchool", sender: self)
                    })
                }
                else{
                    Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                    Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: self)
                }
            })
        }
    }
    
    func setUpTextfield(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    func textDidChange(_ textField: UITextField){
        switch textField.restorationIdentifier! {
        case "email":
            emailValid.image = InputChecker.isValidEmail(text: emailTextField.text!) ? #imageLiteral(resourceName: "Ok_fill") : #imageLiteral(resourceName: "Ok")
        case "password":
            let passwordHasValidLength = InputChecker.hasCorrectLength(min: 6, max: 16, text: passwordTextField.text!)
            let passwordHasValidContent = InputChecker.hasValidPasswordContent(text: passwordTextField.text!)
            let passwordHasNoSpecial = InputChecker.hasNoSpecialLetters(text: passwordTextField.text!)
            passwordValid.image = (passwordHasValidLength && passwordHasValidContent) && passwordHasNoSpecial ? #imageLiteral(resourceName: "Ok_fill") : #imageLiteral(resourceName: "Ok")
            passwordValidLength.image = passwordHasValidLength ? #imageLiteral(resourceName: "Ok_fill") : #imageLiteral(resourceName: "Ok")
            passwordValidContent.image = passwordHasValidContent ? #imageLiteral(resourceName: "Ok_fill") : #imageLiteral(resourceName: "Ok")
            passwordValidSpecial.image = passwordHasNoSpecial ? #imageLiteral(resourceName: "Ok_fill") : #imageLiteral(resourceName: "Ok")
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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // do something?
    }
}

extension WelcomeSignUpTableVC: UITextFieldDelegate{
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

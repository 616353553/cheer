//
//  SignInTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

/**
    Types of sign in view controllers
 
    - regular: Sign in during the use of app. (Navigation bar will show, "continue as tourist" button will hide, and no school needed to be choose after sign in/up.)
 
    - firstTime: First time use this app. ("Continue as tourist" button will show, navigation bar will hide, and the user will be asked to choose a school.)
 */
public enum AuthType {
    case regular
    case firstTime
}

class SignInTVC: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var touristButton: UIButton!
    
    private var authType: AuthType?
    var tap: UITapGestureRecognizer!
    
    
    
    /**
     Used for setting value of "authType".
     
     - parameter authType: Types of sign in view controllers.
     */
    func setAuthType(authType: AuthType){
        self.authType = authType
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if authType == nil{
            if let parent = self.parent as? AuthorizationNVC{
                authType = parent.getAuthType()
            }
        }
        guard authType != nil else {
            fatalError("Error: Must set value for 'authType' before using 'SignInTVC.")
        }
        // set delegates for textfiedlds
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // set buttons with round corners
        ButtonDesign.round(button: signInButton, color: Config.themeColor, radius: 20, borderWidth: 1)
        ButtonDesign.round(button: touristButton, color: Config.themeColor, radius: 13, borderWidth: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set appaerance
        switch authType! {
        case AuthType.regular:
            touristButton.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
        case AuthType.firstTime:
            touristButton.isHidden = false
            self.navigationController?.navigationBar.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = true
        
        // hide the keyboard when touch outside
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        switch authType! {
        case AuthType.firstTime:
            self.navigationController?.navigationBar.isHidden = false
        default:
            break
        }
        self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
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
    
    // change the password visibility
    @IBAction func passwordVisibility(_ sender: UIButton) {
        sender.setImage(passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "visible") : #imageLiteral(resourceName: "invisible"), for: .normal)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func countinueAsTourist(_ sender: UIButton) {
        if Auth.auth().currentUser != nil{
            do {
                try Auth.auth().signOut()
            } catch {
                Alert.displayAlertWithOneButton(title: "Error", message: error.localizedDescription, vc: self)
            }
        }
        signInFinished()
    }
    
    @IBAction func signInIsPushed(_ sender: Any) {
        if emailTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Email address cannot be empty", vc: self)
        } else if passwordTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Password cannot be empty", vc: self)
        } else {
            Authorization.signIn(email: emailTextField.text!, password: passwordTextField.text!, vc: self) { (user, error) in
                if user != nil{
                    self.signInFinished()
                }
            }
        }
    }
    
    @IBAction func cancelIsPushed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    /**        
     Choose a school or dismiss sign in controller based on value of "authType".

     - authType .regular: Dismiss "SignInTVC".
     
     - authType .firstTime: Navigate to "ChooseSchool" storyboard.
     */
    func signInFinished(){
        switch authType! {
        case AuthType.regular:
            self.dismiss(animated: true, completion: nil)
        case AuthType.firstTime:
            let storyboard = UIStoryboard.init(name: "ChooseSchool", bundle: nil)
            self.navigationController?.pushViewController(storyboard.instantiateInitialViewController()!, animated: true)
        }
    }
    
    
    
    
    
    // unwind segue
    @IBAction func unwindToSignInTVC(unwindSeague: UIStoryboardSegue){
        // do something
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 130
        case 1:
            return 44
        case 2:
            return 44
        case 3:
            return UIScreen.main.bounds.height - CGFloat(218)
        default:
            return 0
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignUpTVC{
            vc.authType = self.authType
        }
    }
}

extension SignInTVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

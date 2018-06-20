//
//  SignInVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/18.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    var authType: AuthType!
    var authorizationViewControllerDelegate: AuthorizationViewControllerDelegate!
    private var spinner = UIActivityIndicatorView()
    private var tap: UITapGestureRecognizer!
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBAction func cancelIsPushed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.authorizationViewControllerDelegate.authorizationViewControllerWillDisappear()
        }
    }
    
    @IBAction func passwordVisibility(_ sender: UIButton) {
        sender.setImage(passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "invisible_black") : #imageLiteral(resourceName: "visible_black"), for: .normal)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                Alert.displayAlertWithOneButton(title: "Error", message: error.localizedDescription, vc: self)
            }
        }
        signInSucceed()
    }
    
    @IBAction func signInIsPushed(_ sender: Any) {
        if emailTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Email address cannot be empty", vc: self)
        } else if passwordTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Password cannot be empty", vc: self)
        } else {
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){(user, error) in
                Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                if error == nil {
                    self.signInSucceed()
                } else {
                    Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: self)
                }
            }
        }
    }
    
    // unwind segue
    @IBAction func unwindToSignInVC(unwindSeague: UIStoryboardSegue){
        // do something?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // set buttons' radius
        signInButton.layer.cornerRadius = 20
        skipButton.layer.cornerRadius = 20
        
        // hide the keyboard when touch outside
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        skipButton.isHidden = (authType! != .firstTime)
        self.navigationController?.navigationBar.isHidden = (authType! == .firstTime)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
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
    
    
    
    
    /**
     Choose a school or dismiss sign in controller based on value of "authType".
     
     - authType .regular: Dismiss "SignInVC".
     
     - authType .firstTime: Navigate to "ChooseSchool" storyboard.
     */
    
    func signInSucceed(){
        switch authType! {
        case AuthType.regular:
            self.dismiss(animated: true) {
                self.authorizationViewControllerDelegate.authorizationViewControllerWillDisappear()
            }
        case AuthType.firstTime:
            let vc = ChooseSchoolTableViewController(delegate: self)
            vc.presentOn(navigationController: self.navigationController!)
        }
    }
    

     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp" {
            let vc = segue.destination as! SignUpVC
            vc.authType = self.authType
            vc.authorizationViewControllerDelegate = self.authorizationViewControllerDelegate
        }
    }


}

extension SignInVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignInVC: ChooseSchoolTVCDelegate {
    func schoolChoosed(schoolName: String) {
        if let errorString = CoreDataManagement.updateSchool(schoolName: schoolName) {
            Alert.displayAlertWithOneButton(title: "Error", message: errorString, vc: self)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateInitialViewController()
            self.present(mainVC!, animated: false) {
                self.authorizationViewControllerDelegate.authorizationViewControllerWillDisappear()
            }
        }
    }
}

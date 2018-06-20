//
//  SignUpVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/19.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {

    var authType: AuthType!
    var authorizationViewControllerDelegate: AuthorizationViewControllerDelegate!
    private var tap: UITapGestureRecognizer!
    private var spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpIsPushed(_ sender: UIButton) {
        if nameTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Name cannot be empty", vc: self)
        } else if emailTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Email address cannot be empty", vc: self)
        } else if passwordTextField.text! == "" {
            Alert.displayAlertWithOneButton(title: "Error", message: "Password cannot be empty", vc: self)
        } else {
            let userData = ["email": emailTextField.text!, "password": passwordTextField.text!, "name": nameTextField.text!]
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            let action = NERequestAction.init(endPoint: "sign_up", httpBody: userData) { (metadata, dataBaseError, requestError) in
                if requestError != nil {
                    Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                    Alert.displayAlertWithOneButton(title: "Error", message: "Unknown error", vc: self)
                } else if dataBaseError is NSString {
                    Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                    Alert.displayAlertWithOneButton(title: "error", message: dataBaseError as! String, vc: self)
                } else {
                    Auth.auth().signIn(withEmail: userData["email"]!, password: userData["password"]!){(user, error) in
                        Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                        if error != nil {
                            Alert.displayAlertWithOneButton(title: "Error", message: "Cannot sign in, please try again later", vc: self)
                        } else {
                            Alert.displayAlertWithOneButton(title: "Success", message: "Sign up cucceed", vc: self){(action) in
                                if self.authType == .firstTime {
                                    let schoolPicker = ChooseSchoolTableViewController(delegate: self)
                                    schoolPicker.presentOn(navigationController: self.navigationController!)
                                } else {
                                    self.dismiss(animated: true, completion: {
                                        self.authorizationViewControllerDelegate.authorizationViewControllerWillDisappear()
                                    })
                                }
                            }
                        }
                    }
                }
            }
            let controller = NERequestController()
            controller.add(request: action)
            controller.sendRequests()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        signUpButton.layer.cornerRadius = 20
        
        // hide the keyboard when touch outside
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpVC: ChooseSchoolTVCDelegate {
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

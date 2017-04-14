//
//  WelcomeSignInTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import Firebase

class WelcomeSignInTableVC: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var touristButton: UIButton!

    var tap: UITapGestureRecognizer!
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // sign in button round corner
        signInButton.layer.cornerRadius = 20
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        signInButton.titleLabel?.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        // tourist button round corner
        touristButton.layer.cornerRadius = 13
        touristButton.layer.borderWidth = 1
        touristButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        touristButton.titleLabel?.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        // hide the keyboard when touch outside
        NotificationCenter.default.addObserver(self, selector: #selector(PostItemTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostItemTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(WelcomeSignInTableVC.dismissKeyboard))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func countinueWithoutSignIn(_ sender: UIButton) {
        if FIRAuth.auth()!.currentUser != nil{
            do {
                try FIRAuth.auth()!.signOut()
            }
            catch {
                Alert.displayAlertWithOneButton(title: "Error", message: error.localizedDescription, vc: self)
            }
        }
        self.performSegue(withIdentifier: "selectSchool", sender: self)
    }
    
    @IBAction func signInButtonIsPushed(_ sender: UIButton) {
        if emailTextField.text! == ""{
            Alert.displayAlertWithOneButton(title: "Error", message: "Email address cannot be empty", vc: self)
        }
        else if passwordTextField.text! == ""{
            Alert.displayAlertWithOneButton(title: "Error", message: "Password cannot be empty", vc: self)
        }
        else{
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            // Send a request to login
            FIRAuth.auth()!.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                if user != nil{
                    self.performSegue(withIdentifier: "selectSchool", sender: self)
                }
                else{
                    Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: self)
                }
            })
        }
    }
    
    @IBAction func unwindToWelcomeSignInTableVC(unwindSeague: UIStoryboardSegue){
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
            return 200
        case 1:
            return 44
        case 2:
            return 44
        case 3:
            return UIScreen.main.bounds.height - CGFloat(288)
        default:
            return 0
        }
    }
}

extension WelcomeSignInTableVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

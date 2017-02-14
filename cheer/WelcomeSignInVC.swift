//
//  WelcomeSignInVC.swift
//  cheer
//
//  Created by bainingshuo on 16/10/18.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import UIKit
import Parse

class WelcomeSignInVC: UIViewController{
    
    @IBOutlet weak var logInButton: UIButton!
    
    var emailAddress: String?
    var password: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if emailAddress == nil || password == nil{
            logInButton.isEnabled = false
        }
        let vc = self.childViewControllers[0] as! WelcomeSignInTableVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logInButtonIsPushed(_ sender: UIButton) {
//        if emailAddress == nil || password == nil{
//            logInButton.isEnabled = false
//        }
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        // Send a request to login
        PFUser.logInWithUsername(inBackground: emailAddress!, password: password!, block: {(user, error) -> Void in
            // Stop the spinner
            spinner.stopAnimating()
            if ((user) != nil) {
                self.performSegue(withIdentifier: "LogInSuccessed", sender: self)
                
            } else {
                let alert = UIAlertController.init(title: "Error", message: "\(error)", preferredStyle: .alert)
                //let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show(self, sender: self)
            }
        })
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

// hide the keyboard when hit "return" button
extension WelcomeSignInVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

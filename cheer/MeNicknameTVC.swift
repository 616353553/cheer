//
//  MeNicknameTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class MeNicknameTVC: UITableViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBAction func clearPushed(_ sender: UIButton) {
        nicknameTextField.text = nil
    }
    
    @IBAction func savePushed(_ sender: UIBarButtonItem) {
        if let nickname = nicknameTextField.text {
            if InputChecker.hasCorrectLength(min: 1, max: 32, text: nickname) {
                let originalNickname = userProfile.getNickname()
                userProfile.setNickname(nickname: nickname)
                Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
                userProfile.update(completion: { (errorString) in
                    Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
                    if errorString != nil {
                        userProfile.setNickname(nickname: originalNickname)
                        Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
                    } else {
                        Alert.displayAlertWithOneButton(title: "Success", message: "Nickname updated successfully", vc: self, alertActionHandler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                })
            } else {
                Alert.displayAlertWithOneButton(title: "Error", message: "Nickname must has no more than 32 characters", vc: self)
            }
        } else {
            Alert.displayAlertWithOneButton(title: "Error", message: "Nickname cannot be empty", vc: self)
        }
    }
    
    var userProfile: UserProfile!
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.becomeFirstResponder()
        nicknameTextField.text = userProfile.getNickname()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


}

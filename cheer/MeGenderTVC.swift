//
//  MeGenderTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class MeGenderTVC: UITableViewController {

    @IBOutlet var checkMarks: [UIImageView]!
    @IBAction func savePushed(_ sender: UIBarButtonItem) {
        let originalGender = userProfile.getGender()
        userProfile.setGender(gender: chosenGender)
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
        userProfile.update { (errorString) in
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            if errorString != nil {
                userProfile.setGender(gender: originalGender)
                Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
            } else {
                Alert.displayAlertWithOneButton(title: "Success", message: "Gender info updated successfully", vc: self, alertActionHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    var userProfile: UserProfile!
    var chosenGender: Gender!
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenGender = userProfile.getGender()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateCheckMarks() {
        for checkMark in checkMarks {
            checkMark.isHidden = checkMark.tag != chosenGender.hashValue
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            chosenGender = Gender.male
        case 1:
            chosenGender = Gender.female
        case 2:
            chosenGender = Gender.none
        default:
            chosenGender = Gender.none
        }
        updateCheckMarks()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

}

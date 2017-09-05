//
//  MeDescriptionTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class MeDescriptionTVC: UITableViewController {

    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBAction func savePushed(_ sender: UIBarButtonItem) {
        let description = userProfile.getDescription()
        userProfile.setDescription(description: descriptionTextView.text)
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
        userProfile.update(){ (errorString) in
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            if errorString != nil {
                userProfile.setDescription(description: description)
                Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
            } else {
                Alert.displayAlertWithOneButton(title: "Success", message: "Description updated successfully", vc: self, alertActionHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    var userProfile: UserProfile!
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = userProfile.getDescription()
        setPlaceholderLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setPlaceholderLabel() {
        let count = descriptionTextView.text.characters.count
        counterLabel.textColor = count > 150 ? .red : .lightGray
        counterLabel.isHidden = count > 0
        counterLabel.text = "\(count)/150 Letters"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}


extension MeDescriptionTVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setPlaceholderLabel()
    }
}

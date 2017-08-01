//
//  CommentEditVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CommentEditVC: UIViewController {

    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func cancelPushed(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPushed(_ sender: UIBarButtonItem) {
        let spinner = UIActivityIndicatorView()
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
        comment.upload { (errorString, reference) in
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            if errorString != nil {
                Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
            } else {
                Alert.displayAlertWithOneButton(title: "Success", message: "Comment uploaded sucessfully", vc: self, alertActionHandler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    var comment: Comment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.parent as! CommentEditNVC
        self.comment = vc.comment
        switch comment.getCommentType() {
        case .comment:
            recipientLabel.text = nil
        case .reply:
            recipientLabel.text = "+ \(comment.getRecipient()!.getUserName())"
        }
        textView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
}

extension CommentEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = (textView.text != "")
        comment.setContent(content: textView.text)
    }
}

//
//  CommentEditVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CommentEditVCDelegate {
    func commentPosted()
}

class CommentEditVC: UIViewController {

    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func cancelPushed(_ sender: UIBarButtonItem) {
        Alert.displayAlertWithTwoButtons(title: "Alert", message: "Performing this action will discard all the changes you have made", vc: self) { (action) in
            self.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }
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
                    self.dismiss(animated: true, completion: { 
                        self.delegate.commentPosted()
                    })
                })
            }
        }
    }
    
    var comment: Comment!
    var delegate: CommentEditVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.parent as! CommentEditNVC
        self.comment = vc.comment
        self.delegate = vc.commentEditVCDelegate
        switch comment.getCommentType() {
        case .comment:
            recipientLabel.text = nil
            navigationItem.title = "Comment"
            placeholderLabel.text = "Enter comment here"
        case .reply:
            recipientLabel.text = "+ \(comment.getRecipient()!.getNickname())"
            navigationItem.title = "Reply"
            placeholderLabel.text = "Enter reply here"
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

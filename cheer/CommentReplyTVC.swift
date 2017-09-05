//
//  CommentReplyTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/26.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentReplyTVC: UITableViewController {
    
    @IBAction func addReplyPushed(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser == nil{
            let authVC = AuthorizationViewController()
            authVC.initialize(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        }else{
            addReply(parentDirectory: replies.getParentDirectory(), recipientID: commentAuthorID)
        }
    }
    
    var replies: CommentList!
    var commentAuthorID: String!
    var createReply: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        
        setTableViewBackground(text: "loading replies...")
        let spinner = UIActivityIndicatorView()
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self)
        replies.loadMoreIfPossible(cleanData: false){ (snapshot) in
            if self.replies.count() == 0 {
                self.setTableViewBackground(text: "There is no reply yet")
            } else {
                self.setTableViewBackground(text: nil)
            }
            self.tableView.reloadData()
            Spinner.disableActivityIndicator(activityIndicator: spinner)
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.groupTableViewBackground
        self.refreshControl!.tintColor = UIColor.darkGray
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Refreshing data...")
        self.refreshControl!.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.refreshControl!.addTarget(self, action: #selector(refreshReplies), for: UIControlEvents.valueChanged)
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        if createReply {
            addReply(parentDirectory: replies.getParentDirectory(), recipientID: commentAuthorID)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    func setTableViewBackground(text: String?) {
        if text == nil {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = text
            noDataLabel.textColor = UIColor.darkGray
            noDataLabel.font = UIFont(name: "Helvetica", size: 12.0)
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
    }
    
    func addReply(parentDirectory: String, recipientID: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentEditNVC") as! CommentEditNVC
        vc.commentEditVCDelegate = self
        vc.comment = Comment()
        vc.comment.initialize(commentType: .reply, parentDirectory: parentDirectory, recipientID: recipientID)
        self.present(vc, animated: true, completion: nil)
    }
    
    func reportReply(indexPath: IndexPath) {
        if Auth.auth().currentUser == nil {
            let authVC = AuthorizationViewController()
            authVC.initialize(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        } else {
            let reportVC = ReportViewController()
            reportVC.initialize(directory: replies.getComment(at: indexPath.row).getDirectory(), reasons: ["Inappropriate Content" : "Verbal abuse/insulting/etc.", "Spam": "Ads/etc."])
            reportVC.presentFromBottom(viewController: self, completion: nil)
        }
    }
    
    func refreshReplies() {
        replies.loadMoreIfPossible(cleanData: true) { (snapshot) in
            self.refreshControl?.endRefreshing()
            self.setTableViewBackground(text: self.replies.count() == 0 ? "There is no reply yet" : nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return replies.count() > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !self.refreshControl!.isRefreshing else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell") as! CommentTVCell
        cell.updateCell(commentType: .reply, comment: replies.getComment(at: indexPath.row), indexPath: indexPath, delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}










extension CommentReplyTVC: CommentTVCellDelegate {
    func replyPushed(indexPath: IndexPath) {
        if Auth.auth().currentUser == nil{
            let authVC = AuthorizationViewController()
            authVC.initialize(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        }else{
            addReply(parentDirectory: replies.getParentDirectory(), recipientID: replies.getComment(at: indexPath.row).getAuthor().getUID())
        }
    }
    
    func readReplyPushed(indexPath: IndexPath) {
        // should not be called
        return
    }
    
    func morePushed(indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "Reply", message: "More options", preferredStyle: .actionSheet)
        let replyAction = UIAlertAction(title: "Reply", style: .default) { (action) in
            self.addReply(parentDirectory: self.replies.getParentDirectory(), recipientID: self.replies.getComment(at: indexPath.row).getAuthor().getUID())
        }
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (action) in
            self.reportReply(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // add actions to action sheet
        actionSheet.addAction(replyAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)

    }
}









extension CommentReplyTVC: CommentEditVCDelegate {
    func commentPosted() {
        refreshReplies()
    }
}







extension CommentReplyTVC: AuthorizationViewControllerDelegate {
    func authorizationViewControllerWillDisappear() {
        
    }
}

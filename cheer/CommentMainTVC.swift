//
//  CommentMainTVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentMainTVC: UITableViewController {
    
    @IBAction func addCommentPushed(_ sender: UIBarButtonItem) {
        addComment()
    }
    
    var comments: CommentList!
    var selectedIndexPath: IndexPath?
    var createReply = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        
        setTableViewBackground(text: "loading comments...")
        let spinner = UIActivityIndicatorView()
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self)
        comments.loadMoreIfPossible(cleanData: false){ (snapshot) in
            if self.comments.count() == 0 {
                self.setTableViewBackground(text: "There is no comment yet")
            } else  {
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
        self.refreshControl!.addTarget(self, action: #selector(refreshComments), for: UIControlEvents.valueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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
    
    
    func refreshComments() {
        comments.loadMoreIfPossible(cleanData: true) { (snapshot) in
            self.refreshControl!.endRefreshing()
            self.setTableViewBackground(text: self.comments.count() == 0 ? "There is no comment yet" : nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func addComment() {
        if Auth.auth().currentUser == nil{
            let authVC = AuthorizationViewController()
            authVC.initialize(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentEditNVC") as! CommentEditNVC
            vc.comment = Comment()
            vc.comment.initialize(commentType: .comment, parentDirectory: comments.getParentDirectory(), recipientID: nil)
            vc.commentEditVCDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func replyComment(indexPath: IndexPath) {
        if Auth.auth().currentUser == nil {
            let authVC = AuthorizationViewController()
            authVC.initialize(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        } else {
            selectedIndexPath = indexPath
            createReply = true
            performSegue(withIdentifier: "toReplies", sender: self)
        }
    }
    
    func reportComment(indexPath: IndexPath) {
        if Auth.auth().currentUser == nil {
            let authVC = AuthorizationViewController()
            authVC.initialize(authType: .regular, delegate: self)
            authVC.presentFromBottom(viewController: self, completion: nil)
        } else {
            let reportVC = ReportViewController()
            reportVC.initialize(directory: comments.getComment(at: indexPath.row).getDirectory(), reasons: ["Inappropriate Content" : "Verbal abuse/insulting/etc.", "Spam": "Ads/etc."])
            reportVC.presentFromBottom(viewController: self, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReplies" {
            let vc = segue.destination as! CommentReplyTVC
            guard selectedIndexPath != nil else {
                return
            }
            vc.replies = CommentList()
            vc.replies.initialize(parentDirectory: comments.getComment(at: selectedIndexPath!.row).getDirectory(), directory: comments.getComment(at: selectedIndexPath!.row).getChildDirectory(), numOfQuery: 20, commentType: .reply)
            vc.commentAuthorID = comments.getComment(at: selectedIndexPath!.row).getAuthor().getUID()
            vc.createReply = createReply
            createReply = false
            selectedIndexPath = nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count() > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !self.refreshControl!.isRefreshing else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell") as! CommentTVCell
        cell.updateCell(commentType: .comment, comment: comments.getComment(at: indexPath.row), indexPath: indexPath, delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}







extension CommentMainTVC: CommentTVCellDelegate {
    func replyPushed(indexPath: IndexPath) {
        replyComment(indexPath: indexPath)
    }
    
    func readReplyPushed(indexPath: IndexPath) {
        selectedIndexPath = indexPath
        createReply = false
        performSegue(withIdentifier: "toReplies", sender: self)
    }
    
    func morePushed(indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "Comment", message: "More options", preferredStyle: .actionSheet)
        let replyAction = UIAlertAction(title: "Reply", style: .default) { (action) in
            self.replyComment(indexPath: indexPath)
        }
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (action) in
            self.reportComment(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // add actions to action sheet
        actionSheet.addAction(replyAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}







extension CommentMainTVC: CommentEditVCDelegate {
    func commentPosted() {
        refreshComments()
    }
}






extension CommentMainTVC: AuthorizationViewControllerDelegate {
    func authorizationViewControllerWillDisappear() {
        
    }
}

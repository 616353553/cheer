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
    
    var comments: CommentList!
    var cellStates = [CellState]()
    var selectedIndexPath: IndexPath?
    
    @IBAction func addCommentPushed(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser == nil{
            let storyboard = UIStoryboard.init(name: "Authorization", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! AuthorizationNVC
            vc.setAuthType(authType: .regular)
            self.present(vc, animated: true, completion: nil)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentEditNVC") as! CommentEditNVC
            vc.comment = Comment()
            vc.comment.initialize(commentType: .comment, directory: comments.getDirectory(), recipientID: nil)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        comments.loadMoreIfPossible(){ (snapshot) in
            if snapshot.exists() {
                self.tableView.reloadData()
            } else {
                // no more comments to be loaded
            }
        }
        //tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReplies" {
            let vc = segue.destination as! CommentReplyTVC
            guard selectedIndexPath != nil else {
                return
            }
            let replies = CommentList()
            replies.initialize(directory: comments.getComment(atIndex: selectedIndexPath!.row)!.getDirectory(), numOfQuery: 20, commentType: .reply)
            vc.replies = replies
            selectedIndexPath = nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.getCommentsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell") as! CommentTVCell
        cell.updateCell(comment: comments.getComment(atIndex: indexPath.row)!, cellState: cellStates[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toReplies", sender: self)
    }
}

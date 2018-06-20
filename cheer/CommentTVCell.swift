//
//  CommentTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CommentTVCellDelegate {
    func replyPushed(indexPath: IndexPath)
    func readReplyPushed(indexPath: IndexPath)
    func morePushed(indexPath: IndexPath)
}

class CommentTVCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var firstDotLabel: UILabel!
    @IBOutlet weak var readReplyButton: UIButton!
    
    @IBAction func replyPushed(_ sender: UIButton) {
        delegate.replyPushed(indexPath: indexPath)
    }
    
    @IBAction func readReplyPushed(_ sender: UIButton) {
        delegate.readReplyPushed(indexPath: indexPath)
    }
    
    @IBAction func morePushed(_ sender: UIButton) {
        delegate.morePushed(indexPath: indexPath)
    }
    
    private var delegate: CommentTVCellDelegate!
    private var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        initialize()
    }
    
    private func initialize(){
        userIcon.layer.cornerRadius = 14
        userIcon.image = nil
        userName.text = nil
        content.text = nil
        postTime.text = nil
        readReplyButton.setTitle(nil, for: .normal)
        indexPath = nil
        delegate = nil
    }
    
    func updateCell(comment: Comment, indexPath: IndexPath, delegate: CommentTVCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.userName.text = comment.getAuthor()!.getName()
        self.content.text = comment.getContent()
        self.postTime.text = comment.getTime()
        let replyCount = comment.getReplyCount()!
        if replyCount > 999 {
            self.readReplyButton.setTitle("Read replies (999+)", for: .normal)
        } else {
            self.readReplyButton.setTitle("Read replies (\(replyCount))", for: .normal)
        }
        self.readReplyButton.isHidden = false
        self.firstDotLabel.isHidden = false
        layoutIfNeeded()
    }
}

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
    func unfoldPushed(cellState: CellState, indexPath: IndexPath)
}

class CommentTVCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBAction func commentIsPushed(_ sender: UIButton) {
        delegate.replyPushed(indexPath: indexPath)
    }
    
    @IBAction func unfoldIsPushed(_ sender: UIButton) {
        switch cellState! {
        case .contracted:
            delegate.unfoldPushed(cellState: .expanded, indexPath: indexPath)
        case .expanded:
            delegate.unfoldPushed(cellState: .contracted, indexPath: indexPath)
        }
    }
    
    var delegate: CommentTVCellDelegate!
    var indexPath: IndexPath!
    var cellState: CellState!
    
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
    
    func initialize(){
        userIcon.layer.cornerRadius = 14
        userIcon.image = nil
        userName.text = nil
        content.text = nil
        postTime.text = nil
        replyButton.setTitle(nil, for: .normal)
        indexPath = nil
        cellState = nil
    }
    
    func updateCell(comment: Comment, cellState: CellState, indexPath: IndexPath) {
        self.cellState = cellState
        self.indexPath = indexPath
        self.userName.text = comment.getUID()
        self.content.text = comment.getContent()
        switch cellState {
        case .contracted:
            unfoldButton.setTitle("unfold", for: .normal)
        case .expanded:
            unfoldButton.setTitle("fold", for: .normal)
        }
        let replyCount = comment.getReplyCount()
        if replyCount > 999 {
            self.replyButton.setTitle("Reply (999+)", for: .normal)
        } else {
            self.replyButton.setTitle("Reply (\(replyCount))", for: .normal)
        }
        layoutIfNeeded()
    }
}

//
//  GroupQueueTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupQueueTVCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initialize() {
        userImage.layer.cornerRadius = 14.0
        userImage.image = #imageLiteral(resourceName: "userIcon")
        userNameLabel.text = nil
    }
    
//    func updateCell(memeber: QueueMember) {
//        if memeber.getUserName() == nil || memeber.getUserImage().getImage(atIndex: 0) == nil {
//
//        } else {
//            userImage.image = memeber.getUserImage().getImage(atIndex: 0)
//            userNameLabel.text = memeber.getUserName()
//        }
//    }
    
}

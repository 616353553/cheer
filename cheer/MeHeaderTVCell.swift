//
//  MeHeaderTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/1.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol MeHeaderTVCellDelegate {
    func userIconPushed()
}

class MeHeaderTVCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var userIcon: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func UserIconPushed(_ sender: UIButton) {
        delegate.userIconPushed()
    }
    
    var user: UserProfile?
    var delegate: MeHeaderTVCellDelegate!
    
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
        background.backgroundColor = Config.themeColor
        userIcon.setImage(nil, for: .normal)
        userIcon.imageView?.layer.borderWidth = 4
        userIcon.imageView?.layer.borderColor = UIColor.white.cgColor
        userIcon.imageView?.layer.cornerRadius = 42.5
        userNameLabel.text = nil
    }
    
    func updateCell(user: UserProfile?, delegate: MeHeaderTVCellDelegate) {
        self.delegate = delegate
        if user != nil {
            if let userIconImage = user?.getPortrait().getImage(atIndex: 0) {
                userIcon.setImage(userIconImage, for: .normal)
            } else {
//                user?.getUserImage().retrieveImage(atIndex: 0, completion: { (image, error) in
//                    if error == nil {
//                        self.userIcon.setImage(image!, for: .normal)
//                    } else {
//                        
//                    }
//                }, progress: { (snapshot) in
//                    
//                }, success: { (snapshot) in
//                    
//                }, failure: { (snapshot) in
//                    
//                })
            }
        } else {
            
        }
    }
    
}

//
//  GroupDetailImageHeaderTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseStorage

class GroupDetailImageHeaderTVCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var departments: UILabel!
    @IBOutlet weak var professors: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var imageRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
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
    
    func initialize() {
        title.text = nil
        departments.text = nil
        professors.text = nil
        groupImage.image = nil
    }
    
    func updateCell(title: String, departments: [String?], professors: [String?], imageData: ImageData) {
        self.title.text = title
        
        // set departments
        if departments.count == 0 {
            
        } else {
            
        }
        
        // set professors
        if professors.count == 0 {
            
        } else {
            
        }
        
        // retrieve image
        if imageData.numOfImages() == 0 {
            imageBottomConstraint.constant = 0
            imageRatioConstraint = NSLayoutConstraint(item: self.groupImage,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: self.groupImage,
                                                      attribute: .width,
                                                      multiplier: 0/13,
                                                      constant: 0)
        } else {
            imageBottomConstraint.constant = 12
            imageRatioConstraint = NSLayoutConstraint(item: self.groupImage,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: self.groupImage,
                                                      attribute: .width,
                                                      multiplier: 8/13,
                                                      constant: 0)
            if imageData.getImage(atIndex: 0) == nil && imageData.getDirectories()[0] != nil {
                let ref = Storage.storage().reference()
                ref.child(imageData.getDirectories()[0]!).getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.groupImage.image = image
                        imageData.setImage(atIndex: 0, image: image)
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                self.groupImage.image = imageData.getImage(atIndex: 0)
            }
        }
        
        self.layoutIfNeeded()
    }
    
}

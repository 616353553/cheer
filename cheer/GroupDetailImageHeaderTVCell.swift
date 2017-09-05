//
//  GroupDetailImageHeaderTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseStorage
import KDCircularProgress

class GroupDetailImageHeaderTVCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var departments: UILabel!
    @IBOutlet weak var professors: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var progressView: KDCircularProgress!
    
    @IBOutlet weak var departmentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var professorTopConstraint: NSLayoutConstraint!
    
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
        self.title.text = nil
        self.departments.text = nil
        self.professors.text = nil
        self.groupImage.image = nil
        self.blurView.isHidden = true
        self.progressView.isHidden = true
        self.progressView.angle = 0
    }
    
    
    
    
    
    func updateCell(title: String, departments: GroupDepartments, professors: GroupProfessors, imageData: ImageData) {
        self.title.text = title
        self.departmentTopConstraint.constant = (departments.count() == 0) ? 0 : 8
        self.professorTopConstraint.constant = (professors.count() == 0) ? 0 : 8
        self.departments.text = departments.toString()
        self.professors.text = professors.toString()
        
        if imageData.getImage(atIndex: 0) == nil && imageData.getDirectories()[0] != nil {
            // retrieve thumb nail image
            if imageData.getImage(atIndex: 1) == nil && imageData.getDirectories()[1] != nil {
                imageData.retrieveImage(atIndex: 1, completion: { (thumbImage, error) in
                    if thumbImage != nil {
                        self.progressView.isHidden = true
                        self.blurView.isHidden = false
                        self.groupImage.image = thumbImage
                    }
                    self.retrieveImage(imageData: imageData)
                }, progress: nil, success: nil, failure: nil)
            } else if imageData.getImage(atIndex: 1) != nil {
                self.progressView.isHidden = true
                self.blurView.isHidden = false
                self.groupImage.image = imageData.getImage(atIndex: 1)
                self.retrieveImage(imageData: imageData)
            }
        } else if imageData.getImage(atIndex: 0) != nil {
            self.progressView.isHidden = true
            self.blurView.isHidden = true
            self.groupImage.image = imageData.getImage(atIndex: 0)
        }
        self.layoutIfNeeded()
    }
    
    
    
    
    private func retrieveImage(imageData: ImageData) {
        self.progressView.isHidden = false
        imageData.retrieveImage(atIndex: 0, completion: { (image, error) in
            if image != nil {
                self.blurView.isHidden = true
                self.groupImage.image = image
            }
        }, progress: { (snapshot) in
            if snapshot.progress != nil {
                if snapshot.progress!.totalUnitCount > 0 {
                    self.progressView.angle = Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount) * 360.0
                }
            }
        }, success: { (snapshot) in
            self.progressView.isHidden = true
        }, failure: nil)
    }
    
}

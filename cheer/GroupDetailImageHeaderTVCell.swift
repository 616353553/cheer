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
    
    
    
    
    
    func updateCell(title: String, department: String, professors: ProfessorList, imageData: ImageData) {
        self.title.text = title
        self.departmentTopConstraint.constant = (department == "") ? 0 : 8
        self.professorTopConstraint.constant = (professors.count() == 0) ? 0 : 8
        self.departments.text = department
        self.professors.text = professors[0].getProfessorName()
        
        if imageData.getThumbnailImage(at: 0) == nil {
            imageData.retrieveThumbnailImage(at: 0, completion: { (image, error) in
                if image != nil {
                    self.progressView.isHidden = false
                    self.blurView.isHidden = false
                    self.groupImage.image = image
                }
                self.retrieveOriginalImage(imageData: imageData)
            })
        } else if imageData.getOriginalImage(at: 0) == nil {
            retrieveOriginalImage(imageData: imageData)
        }
        self.layoutIfNeeded()
    }
    
    
    
    
    private func retrieveOriginalImage(imageData: ImageData) {
        self.progressView.isHidden = false
        imageData.retrieveOriginalImage(at: 0, completion: { (image, error) in
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

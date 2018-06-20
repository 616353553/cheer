 //
//  GroupMainImageTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/3.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import UIKit
import KDCircularProgress

class GroupMainImageTVCell: UITableViewCell {
    
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!
    
    @IBOutlet weak var extraInfo: UILabel!
    @IBOutlet weak var extraInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var extraInfoTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var imageRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
    @IBAction func moreIsPushed(_ sender: UIButton) {
        
    }
    
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

        // Configure the view for the selected state
    }
    
    private func initialize(){
        self.groupImage.image = nil
        self.progressView.angle = 0
        self.progressView.isHidden = true
        self.blurView.isHidden = true
        self.title.text = nil
        self.category.text = nil
        self.extraInfo.text = nil
        self.descriptionLabel.text = nil
        self.remaining.text = nil
    }
    
    
    func updateCell(group: Group) {
        self.title.text = group.getTitle()
        self.descriptionLabel.text = group.getDescription()
        self.remaining.text = "\(group.getQueue()?.getMaxSlot() ?? -1) remaining"
        switch group.getGroupType()! {
        case .research:
            updateExtraInfo(text: group.getProfessors()![0].getProfessorName()!)
        case .project:
            updateExtraInfo(text: "")
        case .activity:
            updateExtraInfo(text: "")
        }
        updateImage(imageData: group.getGroupImage()!)
        self.layoutIfNeeded()
    }
    
    
    
    
    
    private func updateExtraInfo(text: String) {
        extraInfoHeightConstraint.constant = (text == "") ? 0 : 14.5
        extraInfoTopConstraint.constant = (text == "") ? 0 : 8
        extraInfo.text = text
    }
    
    
    
    
    private func updateImage(imageData: ImageData) {
        imageRatioConstraint.isActive = imageData.numOfImages() > 0
        imageTopConstraint.constant = (imageData.numOfImages() > 0) ? 12 : 0
        if imageData.numOfImages() > 0 {
            // if has original image
            if let originalImage = imageData.getOriginalImage(at: 0) {
                groupImage.image = originalImage
            } else {
                // if has thumb image
                if let thumbnailImage = imageData.getThumbnailImage(at: 0) {
                    blurView.isHidden = false
                    groupImage.image = thumbnailImage
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
                // if no thumb image
                else {
                    imageData.retrieveThumbnailImage(at: 0, completion: {(image, error) in
                        if image != nil {
                            self.blurView.isHidden = false
                            self.groupImage.image = image
                            self.updateImage(imageData: imageData)
                        }
                    })
                }
            }
        }
    }
    
}

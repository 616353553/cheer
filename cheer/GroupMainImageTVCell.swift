//
//  GroupMainTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/14.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseStorage
import KDCircularProgress

class GroupMainImageTVCell: UITableViewCell {

    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxSlots: UILabel!
    @IBOutlet weak var addBookmarkText: UIButton!
    @IBOutlet weak var addBookmarkImage: UIButton!

    @IBAction func bookmarkPushed(_ sender: UIButton) {
        print("bookmark")
    }
    
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!


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
    
    func initialize(){
        groupImage.image = nil
        progressView.angle = 0
        progressView.isHidden = true
        blurView.isHidden = true
        title.text = nil
        department.text = nil
        professor.text = nil
        descriptionLabel.text = nil
        maxSlots.text = nil
        addBookmarkText.setTitle(nil, for: .normal)
        addBookmarkImage.setImage(nil, for: .normal)
    }
    
    func updateCell(group: Group) {
        self.title.text = group.getTitle()
        self.descriptionLabel.text = group.getDescription()
        self.maxSlots.text = "\(group.getMaxSlots())"
        if group.getGroupType() == .professorProject {
            stackViewHeightConstraint.constant = 14.5
            stackViewTopConstraint.constant = 8
            self.department.text = group.getDepartments()[0]
            self.professor.text = group.getProfessors()[0]
        } else {
            stackViewHeightConstraint.constant = 0
            stackViewTopConstraint.constant = 0
            self.department.text = nil
            self.professor.text = nil
        }
        
        // load image
        
        if group.getImage().getImage(atIndex: 0) != nil {
            groupImage.image = group.getImage().getImage(atIndex: 0)
        } else {
            if let thumbImage = group.getImage().getImage(atIndex: 1) {
                blurView.isHidden = false
                groupImage.image = thumbImage
                retrieveImage(imageData: group.getImage())
            } else {
                group.getImage().retrieveImage(atIndex: 1, completion: {(thumbImage, error) in
                    if error == nil {
                        self.blurView.isHidden = false
                        self.groupImage.image = thumbImage
                        self.retrieveImage(imageData: group.getImage())
                    }
                }, progress: nil, success: nil, failure: nil)
            }
        }
        self.layoutIfNeeded()
    }
    
    private func retrieveImage(imageData: ImageData) {
        progressView.isHidden = false
        imageData.retrieveImage(atIndex: 0, completion: { (image, error) in
            if error == nil {
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

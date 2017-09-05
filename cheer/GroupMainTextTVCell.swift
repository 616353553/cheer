//
//  GroupMainTextTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/20.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupMainTextTVCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxSlots: UILabel!
    @IBOutlet weak var addBookmarkText: UIButton!
    @IBOutlet weak var addBookmarkImage: UIButton!
    
    @IBOutlet weak var departmentProfessorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var departmentProfessorTopConstraint: NSLayoutConstraint!
    
    @IBAction func bookmarkPushed(_ sender: UIButton) {
        print("add pushed")
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
    }
    
    private func initialize() {
        self.title.text = nil
        self.department.text = nil
        self.professor.text = nil
        self.descriptionLabel.text = nil
        self.maxSlots.text = nil
        self.addBookmarkText.setTitle(nil, for: .normal)
        self.addBookmarkImage.setImage(nil, for: .normal)
    }
    
    func updateCell(group: Group) {
        self.title.text = group.getTitle()
        self.descriptionLabel.text = group.getDescription()
        self.maxSlots.text = "\(group.getMaxSlots())"
        if group.getGroupType() == .professorProject {
            self.departmentProfessorTopConstraint.constant = 8
            self.departmentProfessorHeightConstraint.constant = 14.5
            if group.getDepartments().count() > 0 {
                self.department.text = group.getDepartments().get(at: 0)
            }
            if group.getProfessors().count() > 0 {
                self.professor.text = group.getProfessors().get(at: 0)
            }
        } else {
            self.departmentProfessorTopConstraint.constant = 0
            self.departmentProfessorHeightConstraint.constant = 0
            self.department.text = nil
            self.professor.text = nil
        }
        self.layoutIfNeeded()
    }
}

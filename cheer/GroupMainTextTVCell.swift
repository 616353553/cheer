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
        title.text = nil
        department.text = nil
        professor.text = nil
        descriptionLabel.text = nil
        maxSlots.text = nil
        addBookmarkText.setTitle(nil, for: .normal)
        addBookmarkImage.setImage(nil, for: .normal)
    }
    
    func updateCell(group: Group) {
        title.text = group.getTitle()
        descriptionLabel.text = group.getDescription()
        maxSlots.text = "\(group.getMaxSlots())"
        if group.getGroupType() == .professorProject {
            departmentProfessorTopConstraint.constant = 8
            departmentProfessorHeightConstraint.constant = 14.5
            department.text = group.getDepartments()[0]
            professor.text = group.getProfessors()[0]
        } else {
            departmentProfessorTopConstraint.constant = 0
            departmentProfessorHeightConstraint.constant = 0
            department.text = nil
            professor.text = nil
        }
        layoutIfNeeded()
    }
}

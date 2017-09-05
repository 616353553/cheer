//
//  GroupDetailTextHeaderTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/20.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupDetailTextHeaderTVCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var departments: UILabel!
    @IBOutlet weak var professors: UILabel!
    
    @IBOutlet weak var departmentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var professorTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initialize() {
        self.title.text = nil
        self.departments.text = nil
        self.professors.text = nil
    }
    
    func updateCell(title: String, departments: GroupDepartments, professors: GroupProfessors) {
        self.title.text = title
        self.departmentTopConstraint.constant = (departments.count() == 0) ? 0: 8
        self.professorTopConstraint.constant = (professors.count() == 0) ? 0 : 8
        self.departments.text = departments.toString()
        self.professors.text = professors.toString()
        self.layoutIfNeeded()
    }
}

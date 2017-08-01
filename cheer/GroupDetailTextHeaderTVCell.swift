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
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var professor: UILabel!
    
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
    
    private func initialize() {
        title.text = nil
        department.text = nil
        professor.text = nil
    }
    
    func updateCell(title: String, departments: [String?], professors: [String?]) {
        self.title.text = title
        departmentTopConstraint.constant = (departments.count == 0) ? 0: 8
        professorTopConstraint.constant = (professors.count == 0) ? 0 : 8
        self.department.text = arrayToString(array: departments)
        self.professor.text = arrayToString(array: professors)
        layoutIfNeeded()
    }
    
    private func arrayToString(array: [String?]) -> String {
        var str = ""
        if array.count > 0 {
            for element in array {
                if element != nil {
                    str.append(element!)
                    str.append(",")
                }
            }
            str.remove(at: str.endIndex)
        }
        return str
    }
    
}

//
//  ReportReasonTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/6.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class ReportReasonTVCell: UITableViewCell {

    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
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
        reasonLabel.text = nil
        descriptionLabel.text = nil
        checkMark.isHidden = true
    }
    
    func updateCell(reason: String, description: String, isSelected: Bool) {
        reasonLabel.text = reason
        descriptionLabel.text = description
        checkMark.isHidden = !isSelected
    }
    
    func setSelected(isSelected: Bool) {
        checkMark.isHidden = !isSelected
    }
}

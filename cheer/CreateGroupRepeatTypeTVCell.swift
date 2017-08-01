//
//  CreateGroupRepeatTypeTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/8.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupRepeatTypeTVCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var repeatTypeLabel: UILabel!
    
    var repeatType: ScheduleRepeatingType?
    
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
        label.text = nil
        repeatTypeLabel.text = nil
    }
    
    func updateCell(label: String, repeatType: ScheduleRepeatingType?) {
        self.label.text = label
        self.repeatType = repeatType
        switch repeatType! {
        case .repeatByDay:
            repeatTypeLabel.text = "day"
        case .repeatByWeek:
            repeatTypeLabel.text = "week"
        case .repeatByMonth:
            repeatTypeLabel.text = "month"
        }
    }
}

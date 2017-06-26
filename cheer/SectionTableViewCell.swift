//
//  SectionTableViewCell.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/20.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var extra: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    @IBOutlet weak var num: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(data: SectionData){
        num.text = String(self.tag + 1)
        checkmark.alpha = 0
        date.text = data.week ?? "N.A."
        time.text = data.time ?? "N.A"
        location.text = data.location
        professor.text = data.professor
        extra.text = data.others
    }
}

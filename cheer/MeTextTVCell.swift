//
//  MeTextTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/12.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class MeTextTVCell: UITableViewCell {

    @IBOutlet weak var guideLabel: UILabel!
    
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
        guideLabel.text = nil
    }
    
    func updateCell(text: String) {
        guideLabel.text = text
    }
    
}

//
//  DateCVCell.swift
//  cheer
//
//  Created by bainingshuo on 6/16/18.
//  Copyright © 2018 Evolvement Apps. All rights reserved.
//

import UIKit

class DateCVCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initialize()
    }
    
    private func initialize() {
        dateLabel.text = ""
    }
}

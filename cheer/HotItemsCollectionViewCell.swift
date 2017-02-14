//
//  HotItemsCollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class HotItemsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemImage.contentMode = .scaleAspectFill
    }

}

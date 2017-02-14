//
//  DeliveryMethodCollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class DeliveryMethodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deliveryMethodImage: UIImageView!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    var cellIsSelected: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deliveryMethodImage.contentMode = .scaleAspectFill
        cellIsSelected = false
    }
}

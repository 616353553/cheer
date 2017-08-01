//
//  ItemCollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import KDCircularProgress

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.image = nil
        itemImage.contentMode = .scaleAspectFill
        progressView.glowMode = .noGlow
    }
}

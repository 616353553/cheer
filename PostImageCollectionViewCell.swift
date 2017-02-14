//
//  PostImageCollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.contentMode = .scaleAspectFill
    }
}

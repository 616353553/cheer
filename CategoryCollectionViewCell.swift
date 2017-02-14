//
//  CategoryCollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    var cellIsSelected: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.contentMode = .scaleAspectFill
        cellIsSelected = false
//        let tap = UITapGestureRecognizer()
//        tap.cancelsTouchesInView = false
    }
    
}

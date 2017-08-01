//
//  CollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/22.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CollectionViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

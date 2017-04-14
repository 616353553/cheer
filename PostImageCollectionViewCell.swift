//
//  PostImageCollectionViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol PostImageCollectionViewCellDelegate {
    func deleteImage(index: Int)
}

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: PostItemTableVC!
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.contentMode = .scaleAspectFill
    }
    @IBAction func deleteIsPushed(_ sender: UIButton) {
        delegate.deleteImage(index: index)
    }
}

//
//  GroupHeaderTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupHeaderTVCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    
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
    
    func initialize(){
        categoryImage.image = nil
        category.text = nil
    }
    
    func updateCell(image: UIImage, category: String) {
        categoryImage.image = image
        self.category.text = category
    }
    
}

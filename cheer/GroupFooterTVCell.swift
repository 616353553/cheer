//
//  GroupFooterTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupFooterTVCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        initialize()
    }
    
    func initialize(){
        category.text = nil
    }
}

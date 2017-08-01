//
//  GroupTextInfoTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupTextInfoTVCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!


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
    
    func initialize() {
        title.text = nil
        content.text = nil
    }
    
    func updateCell(title: String, text: String) {
        self.title.text = title
        self.content.text = text
        print("cell text \(text)")
        self.layoutIfNeeded()
    }

}

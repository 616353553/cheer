//
//  ItemCell.swift
//  cheer
//
//  Created by bainingshuo on 16/10/14.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var dataOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageOutlet.image = Config.imageHolder
        statusOutlet.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStatus(isActive: Bool){
        statusOutlet.isHidden = false
        if isActive == true{
            statusOutlet.textColor = Config.blueColor
            statusOutlet.text = "Actived"
        }
        else{
            statusOutlet.textColor = Config.redColor
            statusOutlet.text = "Deactived"
        }
    }
}

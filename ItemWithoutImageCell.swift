//
//  ItemWithoutImageCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import Cosmos
import KDCircularProgress

class ItemWithoutImageCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likeCounts: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var viewCounts: UILabel!
    
    var item: Item!
    var isLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeIsPushed(_ sender: UIButton) {
        if isLiked{
            
        }else{
            
        }
    }
    
    func updateCell(){
        userName.text = item.userId
        title.text = item.title
        price.text = item.price
        
    }
}

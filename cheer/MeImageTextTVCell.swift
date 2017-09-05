//
//  MeImageTextTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/1.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class MeImageTextTVCell: UITableViewCell {

    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var guideLabel: UILabel!
    
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
    
    private func initialize() {
        guideImage.image = nil
        guideLabel.text = nil
    }
    
    func updateCell(guideImage: UIImage?, guideText: String) {
        self.guideImage.image = guideImage
        self.guideLabel.text = guideText
    }
    
}

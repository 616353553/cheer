//
//  SchoolCell.swift
//  cheer
//
//  Created by bainingshuo on 16/10/16.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import UIKit

class SchoolCell: UITableViewCell {

    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func prepareForReuse() {
        self.initialize()
    }
    
    private func initialize() {
        self.logo.image = nil
        self.schoolName.text = nil
        self.checkMark.isHidden = true
    }
    
    func updateCell(logo: UIImage?, schoolName: String?) {
        self.logo.image = logo
        self.schoolName.text = schoolName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.checkMark.isHidden = !selected
    }
    
    
    
}

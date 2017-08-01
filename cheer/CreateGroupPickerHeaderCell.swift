//
//  CreateGroupPickerHeaderCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/9.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CreateGroupPickerHeaderCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var indexPath: IndexPath!
    
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
        label.text = nil
        resultLabel.text = nil
        resultLabel.textColor = UIColor.clear
    }
    
    func updateCell(labelText: String?, result: String, isValid: Bool, indexPath: IndexPath) {
        self.label.text = labelText
        self.indexPath = indexPath
        setResutLabel(text: result, isValid: isValid)
    }
    
    func setResutLabel(text: String, isValid: Bool) {
        self.resultLabel.text = text
        if isValid {
            resultLabel.textColor = UIColor.darkGray
        } else {
            resultLabel.textColor = UIColor.red
        }
    }
    
}

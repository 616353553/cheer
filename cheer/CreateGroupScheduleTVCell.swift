//
//  CreateGroupScheduleTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupScheduleTVCellDelegate {
    func deleteButtonPushed(indexPath: IndexPath)
}

class CreateGroupScheduleTVCell: UITableViewCell {

    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet var timeLabels: [UILabel]!
    @IBAction func deleteButtonPushed(_ sender: UIButton) {
        delegate!.deleteButtonPushed(indexPath: indexPath!)
    }
    
    var indexPath: IndexPath?
    var delegate: CreateGroupScheduleTVCellDelegate?
    
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
        
        indexPath = nil
        delegate = nil
    }
    
    func updateCell(text: [[String]], indexPath: IndexPath, delegate: CreateGroupScheduleTVCellDelegate) {
        for i in 0..<dateLabels.count {
            dateLabels[i].text = text[0][dateLabels[i].tag]
        }
        for i in 0..<timeLabels.count {
            timeLabels[i].text = text[1][timeLabels[i].tag]
        }
        self.indexPath = indexPath
        self.delegate = delegate
        self.layoutIfNeeded()
    }
    
}

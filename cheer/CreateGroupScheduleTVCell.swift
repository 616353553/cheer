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
    @IBOutlet weak var scheduleLabel: UILabel!
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
        scheduleLabel.attributedText = nil
        indexPath = nil
        delegate = nil
    }
    
    func updateCell(text: NSMutableAttributedString?, indexPath: IndexPath, delegate: CreateGroupScheduleTVCellDelegate) {
        scheduleLabel.attributedText = text
        self.indexPath = indexPath
        self.delegate = delegate
        self.layoutIfNeeded()
    }
    
}

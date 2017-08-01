//
//  CreateGroupSwitchTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupSwitchTVCellDelegate {
    func switchChanged(isOn: Bool, indexPath: IndexPath)
}

class CreateGroupSwitchTVCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        delegate!.switchChanged(isOn: sender.isOn, indexPath: indexPath!)
    }
    
    private var delegate: CreateGroupSwitchTVCellDelegate?
    private var indexPath: IndexPath?
    
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
        delegate = nil
        label.text = nil
        indexPath = nil
    }
    
    func updateCell(label: String, isOn: Bool, indexPath: IndexPath, delegate: CreateGroupSwitchTVCellDelegate) {
        self.label.text = label
        self.switch.isOn = isOn
        self.delegate = delegate
        self.indexPath = indexPath
    }
}

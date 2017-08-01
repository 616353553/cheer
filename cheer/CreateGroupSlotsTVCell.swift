//
//  CreateGroupSlotsTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupSlotsTVCellDelegate {
    func maxSlotsChanged(value: Int)
}

class CreateGroupSlotsTVCell: UITableViewCell {

    @IBOutlet weak var maxSlotsLabel: UILabel!
    @IBOutlet weak var infiniteButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func infinitePushed(_ sender: UIButton) {
        if maxSlotsLabel.text == "Unlimitied" {
            ButtonDesign.selectButton(button: infiniteButton, setSelect: false)
            maxSlotsLabel.text = String(pickerView.selectedRow(inComponent: 0) + minAllowed!)
            delegate!.maxSlotsChanged(value: Int(maxSlotsLabel.text!)!)
        } else {
            ButtonDesign.selectButton(button: infiniteButton, setSelect: true)
            maxSlotsLabel.text = "Unlimited"
            delegate!.maxSlotsChanged(value: -1)
        }
    }
    
    fileprivate var delegate: CreateGroupSlotsTVCellDelegate!
    private var indexPath: IndexPath!
    fileprivate var minAllowed: Int?
    fileprivate var maxAllowed: Int?
    
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
        maxSlotsLabel.text = nil
        ButtonDesign.round(button: infiniteButton, color: Config.themeColor, radius: 13, borderWidth: 1)
        ButtonDesign.selectButton(button: infiniteButton, setSelect: true)
    }
    
    func updateCell(maxSlots: Int, minAllowed: Int, maxAllowed: Int, indexPath: IndexPath, delegate: CreateGroupSlotsTVCellDelegate) {
        self.minAllowed = minAllowed
        self.maxAllowed = maxAllowed
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        if maxSlots == -1 {
            ButtonDesign.selectButton(button: infiniteButton, setSelect: true)
            pickerView.selectRow(0, inComponent: 0, animated: true)
            maxSlotsLabel.text = "Unlimited"
        } else {
            ButtonDesign.selectButton(button: infiniteButton, setSelect: false)
            pickerView.selectRow(maxSlots - minAllowed, inComponent: 0, animated: false)
            maxSlotsLabel.text = "\(maxSlots)"
        }
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
}

extension CreateGroupSlotsTVCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Config.maxMembersAllowed - Config.minMembersAllowed + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + minAllowed!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        maxSlotsLabel.text = String(row + minAllowed!)
        delegate!.maxSlotsChanged(value: Int(maxSlotsLabel.text!)!)
        ButtonDesign.selectButton(button: infiniteButton, setSelect: false)
    }
}

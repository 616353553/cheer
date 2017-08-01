//
//  CreateGroupPickerTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupPickerTVCellDelegate {
    func pickerChanged(indexPath: IndexPath, frequency: [String])
}

class CreateGroupPickerTVCell: UITableViewCell {

    @IBOutlet weak var picker: UIPickerView!
    
    var indexPath: IndexPath?
    var data: [[String]]?
    var frequency: [String]?
    var delegate: CreateGroupPickerTVCellDelegate?
    
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
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = false
    }
    
    func updateCell(data: [[String]], frequency: [String]?, indexPath: IndexPath, delegate: CreateGroupPickerTVCellDelegate) {
        self.data = data
        self.indexPath = indexPath
        self.delegate = delegate
        self.frequency = frequency
        for i in 0..<data.count {
            picker.selectRow(data[i].index(of: frequency![i])!, inComponent: i, animated: false)
        }
    }
    
    func setVisiable(isVisible: Bool) {
        picker.isHidden = !isVisible
    }
}

extension CreateGroupPickerTVCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data![component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data![component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequency![component] = data![component][row]
        if data!.count == 3 {
            if ["Sunday", "Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday"].contains(frequency![2]) {
                if !["1st", "2nd", "3rd", "4th", "last"].contains(frequency![1]) {
                    picker.selectRow(31, inComponent: 1, animated: false)
                    frequency![1] = data![1][31]
                }
            }
        }
        delegate!.pickerChanged(indexPath: indexPath!, frequency: frequency!)
    }
}

//
//  CreateGroupDatePickerTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupDatePickerTVCellDelegate{
    func dateChanged(date: Date, indexPath: IndexPath)
}

class CreateGroupDatePickerTVCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var delegate: CreateGroupDatePickerTVCellDelegate?
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
        datePicker.locale = Config.locale
        datePicker.isHidden = false
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    func updateCell(date: Date?, pickerMode: UIDatePickerMode, indexPath: IndexPath, delegate: CreateGroupDatePickerTVCellDelegate) {
        self.datePicker.datePickerMode = pickerMode
        if date != nil {
            datePicker.setDate(date!, animated: false)
        }
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    func setVisiable(isVisible: Bool) {
        datePicker.isHidden = !isVisible
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        delegate!.dateChanged(date: sender.date, indexPath: indexPath!)
    }
}

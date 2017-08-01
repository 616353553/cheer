//
//  AddProfessorDepartmentTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

enum ButtonAction {
    case addCell
    case removeCell
}

protocol AddProfessorDepartmentTVCellDelegate{
    func buttonIsPushed(indexPath: IndexPath, action: ButtonAction)
    func textFieldChanged(indexPath: IndexPath, text: String?)
}

class AddProfessorDepartmentTVCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonIsPushed(_ sender: UIButton) {
        delegate!.buttonIsPushed(indexPath: indexPath!, action: buttonAction!)
    }
    
    internal var indexPath: IndexPath?
    internal var placeholder: String?
    internal var delegate: AddProfessorDepartmentTVCellDelegate?
    internal var buttonAction: ButtonAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldChanged(sender:)), for: .editingChanged)
        textField.text = nil
        textField.placeholder = nil
        button.setImage(nil, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.addTarget(self, action: #selector(textFieldChanged(sender:)), for: .editingChanged)
        textField.text = nil
        textField.placeholder = nil
        button.setImage(nil, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldChanged(sender: UITextField){
        delegate!.textFieldChanged(indexPath: indexPath!, text: sender.text)
    }
    
    func updateCell(indexPath: IndexPath, placeholder: String, input: String?, delegate: AddProfessorDepartmentTVCellDelegate, buttonAction: ButtonAction){
        self.indexPath = indexPath
        self.placeholder = placeholder
        self.delegate = delegate
        self.buttonAction = buttonAction
        
        textField.placeholder = placeholder
        textField.text = input
        switch buttonAction {
        case .addCell:
            button.setImage(#imageLiteral(resourceName: "add_blue"), for: .normal)
        case .removeCell:
            button.setImage(#imageLiteral(resourceName: "delete_red"), for: .normal)
        }
    }
}

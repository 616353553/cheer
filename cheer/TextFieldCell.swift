//
//  TextFieldCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/22.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var extraLabeWidth: NSLayoutConstraint!
    @IBOutlet weak var horizontalSpacing: NSLayoutConstraint!
    @IBOutlet weak var check: UIImageView!
    
    var placeHolderText: String?
    var extraLabelText:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(TextFieldCell.textFieldDidChange), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidChange(){
        check.isHidden = !isLegalInput()
    }
    
    func updateCell(){
        textField.placeholder = placeHolderText
        extraLabel.text = extraLabelText
        if extraLabelText == nil || extraLabelText == ""{
            extraLabeWidth.constant = 0
            horizontalSpacing.constant = 0
        }
        check.isHidden = !isLegalInput()
    }
    
    func isLegalInput() -> Bool{
        if textField.text != nil && textField.text! != ""{
            return InputChecker.isDouble(text: textField.text)
        }
        return true
    }
    
    func cellIsTouched(){
        textField.becomeFirstResponder()
    }
}

extension TextFieldCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

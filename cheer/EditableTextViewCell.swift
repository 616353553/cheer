//
//  EditableTextViewCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class EditableTextViewCell: UITableViewCell {

    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var letterCounter: UILabel!
    @IBOutlet weak var letterCounterHeight: NSLayoutConstraint!
    @IBOutlet weak var letterCounterBottom: NSLayoutConstraint!
    
    var placeHolderText: String?
    var maximumLetters: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.isUserInteractionEnabled = false
        textView.returnKeyType = .done
        check.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(){
        placeHolder.text = placeHolderText
        placeHolder.isHidden = (textView.text != "")
        letterCounterHeight.constant = 0
        letterCounterBottom.constant = 0
        if maximumLetters != nil{
            letterCounter.text = "\(textView.text.characters.count)/\(maximumLetters!) Letters"
        } else {
            letterCounter.text = ""
        }
        check.isHidden = !isLegalInput()
    }
    
    func cellIsTouched(){
        textView.isUserInteractionEnabled = true
        textView.becomeFirstResponder()
        if maximumLetters != nil{
            letterCounterHeight.constant = 14
            letterCounterBottom.constant = 8
        }
    }
    
    func isLegalInput() -> Bool{
        if maximumLetters != nil{
            return (textView.text.characters.count <= maximumLetters!) && !InputChecker.onlyHasWhiteSpace(text: textView.text)
        }
        return !InputChecker.onlyHasWhiteSpace(text: textView.text)
    }
}

extension EditableTextViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = (textView.text != "")
        if maximumLetters != nil{
            letterCounter.text = "\(textView.text.characters.count)/\(maximumLetters!) Letters"
        }
        check.isHidden = !isLegalInput()
    }
    
    // end editing when done is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

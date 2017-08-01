//
//  CreateGroupTextViewTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

enum CellState{
    case contracted
    case expanded
}

protocol CreateGroupTextViewTVCellDelegate {
    func textChanged(text: String, indexPath: IndexPath)
}

class CreateGroupTextViewTVCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var validImage: UIImageView!
    
    fileprivate var indexPath: IndexPath!
    fileprivate var delegate: CreateGroupTextViewTVCellDelegate!
    fileprivate var placeHolderText: String?
    
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
        placeHolderLabel.text = nil
        textView.text = nil
        textView.delegate = self
        validImage.image = #imageLiteral(resourceName: "valid_lightGray")
    }
    
    
    
    func updateCell(label: String, text: String?, placeHolder: String, indexPath: IndexPath, delegate: CreateGroupTextViewTVCellDelegate) {
        self.label.text = label
        self.textView.text = text
        self.validImage.image = (textView.text != "" && textView.text != nil) ? #imageLiteral(resourceName: "valid_blue") : #imageLiteral(resourceName: "valid_lightGray")
        self.placeHolderLabel.text = placeHolder
        self.placeHolderText = placeHolder
        self.placeHolderLabel.isHidden = (textView.text != nil && textView.text != "" )
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    func rotateArrow(cellState: CellState) {
        switch cellState {
        case .contracted:
            UIView.animate(withDuration: 0.3){
                self.arrow.transform = CGAffineTransform(rotationAngle: 0)
            }
        case .expanded:
            UIView.animate(withDuration: 0.3){
                self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }
}

extension CreateGroupTextViewTVCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = (textView.text != nil && textView.text != "" )
        self.validImage.image = (textView.text != "" && textView.text != nil) ? #imageLiteral(resourceName: "valid_blue") : #imageLiteral(resourceName: "valid_lightGray")
        delegate!.textChanged(text: textView.text!, indexPath: indexPath!)
    }
}

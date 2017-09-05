//
//  ReportDescriptionTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/6.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol ReportDescriptionTVCellDelegate {
    func textChanged(text: String)
}

class ReportDescriptionTVCell: UITableViewCell {

    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    fileprivate var delegate: ReportDescriptionTVCellDelegate!
    
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
        placeholder.isHidden = false
        textView.delegate = self
    }
    
    func updateCell(description: String, delegate: ReportDescriptionTVCellDelegate) {
        self.textView.text = description
        placeholder.isHidden = description != ""
        updateCounterLabel(description: description)
        self.delegate = delegate
    }
    
    func updateCounterLabel(description: String) {
        let count = description.characters.count
        counterLabel.textColor = count > Config.reportMaxLettersAllowed ? .red : .darkGray
        counterLabel.text = "\(count)/\(Config.reportMaxLettersAllowed) Letters"
    }
    
}


extension ReportDescriptionTVCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = textView.text != ""
        updateCounterLabel(description: textView.text)
        delegate.textChanged(text: textView.text)
    }
}

//
//  CreateGroupImageTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

protocol CreateGroupImageTVCellDelegate {
    func imageChanged(image: UIImage?)
    func editImage(indexPath: IndexPath)
}

class CreateGroupImageTVCell: UITableViewCell {

    @IBOutlet weak var imageButton: UIButton!
    @IBAction func deletePushed(_ sender: UIButton) {
        imageButton.setImage(#imageLiteral(resourceName: "EmptyImage"), for: .normal)
        deleteButton.isHidden = true
        delegate!.imageChanged(image: nil)
    }
    @IBAction func editPushed(_ sender: UIButton) {
        delegate!.editImage(indexPath: indexPath!)
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    private var delegate: CreateGroupImageTVCellDelegate?
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
        imageButton.setImage(nil, for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        deleteButton.isHidden = true
    }
    
    func updateCell(image: UIImage?, indexPath: IndexPath, delegate: CreateGroupImageTVCellDelegate) {
        if image == nil {
            deleteButton.isHidden = true
            imageButton.setImage(#imageLiteral(resourceName: "EmptyImage"), for: .normal)
        } else {
            deleteButton.isHidden = false
            imageButton.setImage(image, for: .normal)
        }
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    func setImage(image: UIImage?) {
        deleteButton.isHidden = (image == nil)
        imageButton.setImage(image, for: .normal)
    }
}

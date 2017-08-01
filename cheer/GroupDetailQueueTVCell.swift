//
//  GroupDetailQueueTVCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class GroupDetailQueueTVCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var availableCount: UILabel!
    @IBOutlet weak var availableText: UILabel!
    @IBOutlet var infoTitles: [UILabel]!
    @IBOutlet var infoContents: [UILabel]!
    
    @IBAction func joinPushed(_ sender: UIButton) {
        print("join")
    }
    
    @IBAction func queuePushed(_ sender: UIButton) {
        print("queue")
    }
    
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
    
    func initialize() {
        colorView.layer.cornerRadius = 8
        colorView.backgroundColor = .clear
        availableCount.text = nil
        availableText.text = nil
        for infoContent in infoContents {
            infoContent.text = nil
        }
    }
    
    func updateCell(maxSlots: Int, memberCount: Int, pendingCount: Int) {
        if maxSlots != -1 {
            availableCount.text = "\(maxSlots - memberCount)"
            if memberCount < maxSlots {
                colorView.backgroundColor = UIColor.init(red: 0, green: 86/255.0, blue: 182/255.0, alpha: 1)
                availableText.text = "AVAILABLE"
            } else {
                colorView.backgroundColor = UIColor.init(red: 188/255.0, green: 0, blue: 11/255.0, alpha: 1)
                availableText.text = "FULL"
            }
        } else {
            colorView.backgroundColor = UIColor.init(red: 0, green: 86/255.0, blue: 182/255.0, alpha: 1)
            availableCount.text = "N/A"
            availableText.text = "AVAILABLE"
        }
        
        for infoTitle in infoTitles {
            switch infoTitle.tag {
            case 0, 1, 2:
                infoTitle.isHidden = false
            case 3:
                infoTitle.isHidden = true
            default:
                break
            }
        }
        
        for infoContent in infoContents {
            switch infoContent.tag {
            case 0:
                infoContent.isHidden = false
                if maxSlots == -1 {
                    infoContent.text = "Unlimited"
                } else {
                    infoContent.text = "\(maxSlots)"
                }
            case 1:
                infoContent.isHidden = false
                infoContent.text = "\(memberCount)"
            case 2:
                infoContent.isHidden = false
                infoContent.text = "\(pendingCount)"
            case 3:
                infoContent.isHidden = true
            default:
                break
            }
        }
        
        
        
    }
    
}

//
//  CustomTextField.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    // with this code, textfield cannot perform "paste" action
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
}

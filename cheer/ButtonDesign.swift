//
//  ButtonDesign.swift
//  cheer
//
//  Created by bainingshuo on 2017/4/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class ButtonDesign{
    // set button frame to round
    static func round(button: UIButton, color: UIColor, radius: CGFloat, borderWidth: CGFloat){
        button.setTitleColor(color, for: .normal)
        button.layer.cornerRadius = radius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = color.cgColor
    }
    
    static func selectButton(button: UIButton, setSelect: Bool){
        if setSelect{
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.backgroundColor = Config.themeColor.cgColor
        }else{
            button.setTitleColor(Config.themeColor, for: .normal)
            button.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}

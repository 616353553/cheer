//
//  InputChecker.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class InputChecker{
    
    // check if the given string only has white spaces
    static func onlyHasWhiteSpace(titleText: String) -> Bool{
        let whiteSpaceSet = NSCharacterSet.whitespaces
        if titleText.trimmingCharacters(in: whiteSpaceSet).isEmpty == false {
            return true
        }
        return false
    }
    
    // check if the given string only has number
    static func onlyHasNumber(price: String!) -> Bool{
        if Double(price) != nil{
            return true
        }
        return false
    }
}

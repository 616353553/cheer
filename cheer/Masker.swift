//
//  Masker.swift
//  cheer
//
//  Created by bainingshuo on 2017/3/24.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
class Masker{
    static func maskEmail(email: String) -> String{
        var result = ""
        var counter = 0
        var atIsFound = false
        for char in email {
            if char == "@"{
                atIsFound = true
            }
            if atIsFound{
                result.append(char)
            }
            else{
                if counter < 2{
                    result.append(char)
                    counter += 1
                }else{
                    result.append("*")
                }
            }
        }
        return result
    }
    
    static func maskPhone(phone: String) -> String{
        var result = ""
        let leading = 4
        let trailing = 2
        let stringLength = phone.count
        var current = 0
        for char in phone {
            if current < leading || current >= stringLength - trailing{
                result.append(char)
            }
            else{
                result.append("*")
            }
            current = current + 1
        }
        return result
    }
}

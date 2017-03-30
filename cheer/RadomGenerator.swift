//
//  RadomGenerator.swift
//  cheer
//
//  Created by bainingshuo on 17/2/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class RandomGernerator{
    static func randomString(length: Int) -> String {
        //let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func randomNumber(length: Int) -> String{
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        var randomNumber = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomNumber += NSString(characters: &nextChar, length: 1) as String
        }
        return randomNumber
    }
    
}

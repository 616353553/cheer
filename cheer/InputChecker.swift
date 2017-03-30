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
    static func onlyHasWhiteSpace(text: String) -> Bool{
        let whiteSpaceSet = NSCharacterSet.whitespaces
        if text.trimmingCharacters(in: whiteSpaceSet).isEmpty == false {
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
    
    // check if the given string has allowed length
    static func hasCorrectLength(min: Int, max: Int, text: String) -> Bool{
        if text.characters.count >= min && text.characters.count <= max{
            return true
        }
        return false
    }
    
    // check if the given string is a valid email
    static func isValidEmail(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    // check if the given string is a valid phone number
    static func isValidPhoneNumber(text: String) -> Bool {
        let PHONE_REGEX = "[0-9]{10,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: text)
        return result
    }
    
    // has at least 1 digit, 1 lower-case letter and 1 upper-case letter
    static func hasValidPasswordContent(text: String) -> Bool{
        let upperCase_REGEX = ".*[A-Z]+.*"
        let lowerCase_REGEX = ".*[a-z]+.*"
        let digits_REGEX = ".*[0-9]+.*"
        
        let result = onlyHasGivenRegex(REGEX: upperCase_REGEX, text: text)
            && onlyHasGivenRegex(REGEX: lowerCase_REGEX, text: text)
            && onlyHasGivenRegex(REGEX: digits_REGEX, text: text)
        return result
    }
    
    // check if the given string only has alphabets and numbers
    static func hasNoSpecialLetters(text: String) -> Bool{
        let alphanumericsSet = NSCharacterSet.alphanumerics
        return text.trimmingCharacters(in: alphanumericsSet) == ""
    }
    
    // check if the given string mathces the given regular expression
    static func onlyHasGivenRegex(REGEX: String, text: String) -> Bool{
        let customTest = NSPredicate(format: "SELF MATCHES %@", REGEX)
        let result = customTest.evaluate(with: text)
        return result
    }
}

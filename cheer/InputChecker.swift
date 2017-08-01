//
//  InputChecker.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class InputChecker{
    
    /**
     
     Check if the given string only has white space (space and tab, etc.).
     
     - parameter text: The String which need to be verified.
     
     - returns: A boolean which indicates whether given string only has white space.
     
     */
    static func onlyHasWhiteSpace(text: String) -> Bool{
        let whiteSpaceSet = NSCharacterSet.whitespaces
        return text.trimmingCharacters(in: whiteSpaceSet).isEmpty
    }
    
    
    
    
    /**
     
     Check if the given string is a double.
     
     - parameter text: The String which need to be verified.
     
     - returns: A boolean which indicates whether given string is a double or not.
     
     */
    static func isDouble(text: String!) -> Bool{
        return Double(text) != nil
    }
    
    
    
    
    /**
     
     Check if the given string is an integer.
     
     - parameter text: The String which need to be verified.
     
     - returns: A boolean which indicates whether given string is an integer or not.
     
     */
    static func isInt(text: String!) -> Bool{
        return Int(text) != nil
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
    
    // contains both of letters(a~z, A~Z) and digits(0~9)
    static func hasValidPasswordContent(text: String) -> Bool{
        let upperCase_REGEX = ".*[A-Z]+.*"
        let lowerCase_REGEX = ".*[a-z]+.*"
        let digits_REGEX = ".*[0-9]+.*"
        
        let result = (onlyHasGivenRegex(REGEX: upperCase_REGEX, text: text) || onlyHasGivenRegex(REGEX: lowerCase_REGEX, text: text))
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

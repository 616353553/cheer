//
//  Alert.swift
//  cheer
//
//  Created by bainingshuo on 17/2/18.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
class Alert{
    // show an alert with one button: "OK"
    static func displayAlertWithOneButton(title: String, message: String, vc: UIViewController, alertActionHandler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: alertActionHandler))
        vc.present(alert, animated: true, completion: nil)
    }
    
    // show an alert with two buttons: "OK" and "Cancel"
    static func displayAlertWithTwoButtons(title: String, message: String, vc: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) -> Void{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}

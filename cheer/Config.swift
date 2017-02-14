//
//  Config.swift
//  cheer
//
//  Created by bainingshuo on 16/10/14.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import Foundation
import UIKit

public struct Config{
    static let UsernameLengthMin: Int = 1
    static let UsernameLengthMax: Int = 16
    static let PasswordLengthMin: Int = 1
    static let PasswordLengthMax: Int = 20
    static let EmailLengthMin: Int = 2
    static let EmailLengthMax: Int = 64
    
    static let maxImagesAllowed: Int = 6
    static let contactMethodChoices = ["Choose Method", "Cellphone", "Email", "Kakao Talk", "LINE", "Messenger", "Whatsapp", "Wechat"]
    static let addPhotoButtonImage = UIImage(named: "AddPhotoButton")
    static let maxContactsAllowed: Int = 3
    
    static let screenSize: CGSize = UIScreen.main.bounds.size
    static let uploadImageQuality: CGFloat = 0.5
    static let minZoomScale: CGFloat = 1.0
    static let maxZoomScale: CGFloat = 3.0
    static let imageHolder: UIImage = UIImage(named: "launch icon")!
    static let queryLimit: Int = 10
    var theme_color: UIColor = UIColor.init(red: 0/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1)
    static let blueColor: UIColor = UIColor.init(red: 0/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1)
    static let redColor: UIColor = UIColor.init(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    static var isFirstRun = true
    static var userIsLoggedIn = false
}

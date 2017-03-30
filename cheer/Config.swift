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
    static let sinchKey = "a6122d00-1c36-41fb-b86d-73c014ed1eac"
    static let mailgunAPIKey = "key-afc1ced29ef576a7be3ff08b3a540351"
    static let mailgunClientDomain = "mg.cheerapp.host"
    static let twilioSID = "ACfe949dd0c6fdd7b1653a00f4281bbcf0"
    static let twilioKey = "608b14f5ecd808ba0692fd4350a21c35"
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
    static var themeColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    static let blueColor: UIColor = UIColor.init(red: 0/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1)
    static let redColor: UIColor = UIColor.init(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    static var isFirstRun = true
    static var userIsLoggedIn = false
}

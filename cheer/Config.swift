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
    
    static let maxImagesAllowed: Int = 9
    
    static let screenSize: CGSize = UIScreen.main.bounds.size
    
    //image maximum size allowed in Bytes
    static let imageMaxSize: Int = 100 * 1024
    static let thumbImageMaxSize: Int = 20 * 1024
//    static let minZoomScale: CGFloat = 1.0
//    static let maxZoomScale: CGFloat = 3.0
    static let imageHolder: UIImage = UIImage(named: "launch icon")!
    static let queryLimit: Int = 10
    static var themeColor = UIColor.init(red: 0, green: 89/255.0, blue: 178/255.0, alpha: 1)
    static let placeHolderColor = UIColor.init(red: 187, green: 187, blue: 194, alpha: 1)
    static let tableViewBackGroundColor = UIColor.init(red: 239, green: 239, blue: 244, alpha: 1)
    static let blueColor: UIColor = UIColor.init(red: 0/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1)
    static let redColor: UIColor = UIColor.init(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    static let tableViewGrey: UIColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)
    static var isFirstRun = true
    static var userIsLoggedIn = false
    static let locale = Locale.init(identifier: "us")
    
    static let groupTitleLength: Int = 300
    static let maxProfessors: Int = 10
    static let maxDepartments: Int = 5
    static let maxSchedules: Int = 8
    static let minMembersAllowed: Int = 1
    static let maxMembersAllowed: Int = 500
    
    
    static let reportMaxLettersAllowed: Int = 300
    
}

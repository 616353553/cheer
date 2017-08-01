//
//  UserPortfolio.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/27.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

fileprivate struct UserPortfolioStruct {
    var uid: String
    var userImage: ImageData
    var userName: String
}

class UserPortfolio {
    
    private var data: UserPortfolioStruct!
    
    func initialize(uid: String) {
        data = UserPortfolioStruct(uid: uid, userImage: ImageData(), userName: "")
        data.userImage.initialize(withCapacity: 1)
    }
    
    func fetchDataFromUID() {
        print("function fetchDataFromUID() is not implemented")
        
    }
    
    func setUID(uid: String) {
        data.uid = uid
    }
    
    func setUserImage(userImage: ImageData) {
        data.userImage = userImage
    }
    
    func setUserName(userName: String) {
        data.userName = userName
    }
    
    func getUID() -> String {
        return data.uid
    }
    
    func getUserImage() -> ImageData {
        return data.userImage
    }
    
    func getUserName() -> String {
        return data.userName
    }
}

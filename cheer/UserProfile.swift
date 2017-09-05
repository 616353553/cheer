//
//  UserProfile.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/27.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum Gender: String {
    case male = "male"
    case female = "female"
    case none = "none"
}

fileprivate struct UserProfileStruct {
    var uid: String
    var portrait: ImageData
    var nickname: String
    var gender: Gender
    var description: String
}

class UserProfile {
    
    private var data: UserProfileStruct!
    
    func initialize(uid: String) {
        data = UserProfileStruct(uid: uid, portrait: ImageData(), nickname: "", gender: .none, description: "")
        data.portrait.initialize(withCapacity: 1)
    }
    
    func fetchDataFromUID(completion: @escaping ((DataSnapshot) -> Void)) {
        
        print("function fetchDataFromUID() is not implemented") 
        
    }
    
    
    
    
    func setUID(uid: String) {
        data.uid = uid
    }
    
    func setPortrait(portrait: ImageData) {
        data.portrait = portrait
    }
    
    func setNickname(nickname: String) {
        data.nickname = nickname
    }
    
    func setGender(gender: Gender) {
        data.gender = gender
    }
    
    func setDescription(description: String) {
        data.description = description
    }
    
    
    
    
    
    
    func getUID() -> String {
        return data.uid
    }
    
    func getPortrait() -> ImageData {
        return data.portrait
    }
    
    func getNickname() -> String {
        return data.nickname
    }
    
    func getGender() -> Gender {
        return data.gender
    }
    
    func getDescription() -> String {
        return data.description
    }
    
    
    
    
    
    func update(completion: ((String?) -> Void)) {
        
    }
}

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
    var name: String
    var gender: Gender
    var description: String
}

class UserProfile {
    
    private var data: UserProfileStruct!
    
    init(uid: String) {
        data = UserProfileStruct(uid: uid, portrait: ImageData(), name: "", gender: .none, description: "")
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
    
    func setName(name: String) {
        data.name = name
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
    
    func getName() -> String {
        return data.name
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

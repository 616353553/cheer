//
//  QueueMemeber.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

struct QueueMemberStruct {
    var groupDirectory: String
    var user: UserProfile
    var time: Date?
}

class QueueMember {
    
    private var data: QueueMemberStruct!
    
    func initialize(groupDirectory: String, uid: String) {
        let user = UserProfile()
        user.initialize(uid: uid)
        data = QueueMemberStruct(groupDirectory: groupDirectory,
                                 user: user,
                                 time: nil)
    }
    
    
    
    
    func setUser(user: UserProfile){
        data.user = user
    }
    
    func setTime(time: Date?) {
        data.time = time
    }
    
    
    
    
    
    func getUser() -> UserProfile {
        return data.user
    }
    
    func getTime() -> Date? {
        return data.time
    }
}

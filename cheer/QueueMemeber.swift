//
//  QueueMemeber.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

struct QueueMemberStruct {
    var uid: String
    var userImage: ImageData
    var userName: String?
}

class QueueMember {
    
    var data: QueueMemberStruct?
    
    func initialize(uid: String) {
        data = QueueMemberStruct(uid: uid, userImage: ImageData(), userName: nil)
        data!.userImage.initialize(withCapacity: 1)
    }
    
    func setUid(uid: String){
        data!.uid = uid
    }
    
    func getUid() -> String {
        return data!.uid
    }
    
    func setUserImage(imageData: ImageData) {
        data!.userImage = imageData
    }
    
    func getUserImage() -> ImageData {
        return data!.userImage
    }
    
    func setUserName(userName: String?) {
        data!.userName = userName
    }
    
    func getUserName() -> String? {
        return data!.userName
    }
}

//
//  Queue.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/14.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MemberStruct {
    var groupRef: String?
    var profile: UserProfile?
    var time: String?
    var reason: String?
    
    func toJSON() -> [String: Any] {
        return ["groupRef": (groupRef ?? "") as Any,
                "uid": (profile?.getUID() ?? "") as Any]
    }
    
    func joinGroup() {
        
    }
}

struct QueueStruct {
    // tiny data
    var reference: String?
    var groupRef: String?
    var creatorID: String?
    var maxSlot: Int?
    var currentCount: Int?
    var pendingCount: Int?
    var memberRef: String?
    var pendingRef: String?
    var rejectRef: String?
    var sendNotification: Bool?
    //mega data
    var current: [MemberStruct]?
    var pending: [MemberStruct]?
    var reject: [MemberStruct]?
}

class Queue {
    
    private var data: QueueStruct!

    init(creatorID: String) {
        data = QueueStruct()
        data?.creatorID = creatorID
    }

    init(reference: String) {
        data = QueueStruct()
        data.reference = reference
    }
    
    
    // Getters
    func getReference() -> String? {
        return data.reference
    }
    
    func getGroupRef() -> String? {
        return data.groupRef
    }
    
    func getCreatorID() -> String? {
        return data.creatorID
    }
    
    func getMaxSlot() -> Int? {
        return data.maxSlot
    }
    
    func getCurrentCount() -> Int? {
        return data.currentCount
    }
    
    func getPendingCount() -> Int? {
        return data.pendingCount
    }
    
    func getCurrent() -> [MemberStruct]? {
        return data.current
    }
    
    func getPending() -> [MemberStruct]? {
        return data.pending
    }
    
    func getReject() -> [MemberStruct]? {
        return data.reject
    }
    
    func getSendNotification() -> Bool? {
        return data.sendNotification
    }
    
    
    
    
    // Setters
    func setMaxSlot(maxSlot:Int) {
        data.maxSlot = maxSlot
    }
    
    func setSendNotification(sendNotification: Bool?) {
        data.sendNotification = sendNotification
    }

}

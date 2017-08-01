//
//  Queue.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/14.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum QueueDataType {
    case creator
    case member
    case pending
}

public struct QueueStruct {
    var creator: String
    var member: [String]
    var pending: [String]
}

class Queue {
    
    private var data: QueueStruct?

    func initialize(creatorId: String) {
        data = QueueStruct(creator: creatorId, member: [], pending: [])
    }
    
    private func getValue(dataType: QueueDataType) -> AnyObject {
        switch dataType {
        case .creator:
            return data!.creator as AnyObject
        case .member:
            return data!.member as AnyObject
        case .pending:
            return data!.pending as AnyObject
        }
    }
    
    private func setValue(dataType: QueueDataType, value: AnyObject) {
        switch dataType {
        case .creator:
            data!.creator = value as! String
        case .member:
            data!.member = value as! [String]
        case .pending:
            data!.pending = value as! [String]
        }
    }
    
    
    
    
    // getters
    func getCreator() -> String {
        return getValue(dataType: .creator) as! String
    }
    
    func getMember() -> [String] {
        return getValue(dataType: .member) as! [String]
    }
    
    func getPending() -> [String] {
        return getValue(dataType: .pending) as! [String]
    }
    
    
    
    
    // setters
    func setCreator(value: String) {
        setValue(dataType: .creator, value: value as AnyObject)
    }
    
    func setMember(value: [String]) {
        setValue(dataType: .member, value: value as AnyObject)
    }
    
    func setPending(value: [String]) {
        setValue(dataType: .pending, value: value as AnyObject)
    }
    
    
    
    func toJSON() -> [String: AnyObject] {
        var queueJSON = ["creator": data!.creator as AnyObject]
        if data!.member != [] {
            queueJSON["member"] = data!.member as AnyObject
        }
        if data!.pending != [] {
            queueJSON["pending"] = data!.pending as AnyObject
        }
        return queueJSON
    }
    
    
    func upload(completion: @escaping (String?, DatabaseReference?)->Void) {
        let action = NERequestAction.init(endPoint: "", httpBody: toJSON()) { (data, dataBaseError, requestError) in
            if dataBaseError == nil && requestError == nil {
                completion(nil, nil)
            } else if dataBaseError != nil {
                completion("Unknown Error", nil)
            } else {
                completion(requestError!.localizedDescription, nil)
            }
        }
        let controller = NERequestController()
        controller.isSequential = true
        controller.add(request: action)
        controller.sendRequests()
    }
}

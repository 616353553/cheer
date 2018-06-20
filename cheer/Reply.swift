//
//  Reply.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/6.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import Foundation

struct ReplyStruct {
    var reference: String?
    var parentRef: String?
    var author: UserProfile?
    var recipient: UserProfile?
    var content: String?
    var time: String?
}

class Reply {
    
    private var data: ReplyStruct!
    
    init(authorID: String, recipientID: String, parentRef: String) {
        data = ReplyStruct()
        data.author = UserProfile(uid: authorID)
        data.recipient = UserProfile(uid: recipientID)
        data.parentRef = parentRef
    }
    
    init(reference: String) {
        data = ReplyStruct()
        data.reference = reference
    }
}

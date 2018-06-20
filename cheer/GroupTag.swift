//
//  GroupTag.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/5.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import Foundation

private struct GroupTagStruct {
    var reference: String?
    var tagName: String?
    var tagImage: ImageData?
    var creatorID: String?
    var tagDescription: String?
    var childCounter: Int?
    var childRefs: [String]?
    var related: [String]?
}

class GroupTag {
    
    private var data: GroupTagStruct!
    
    init(data: [String: Any]) {
        
    }
    
    init(creatorID: String, tagName: String, description: String) {
        
    }
    
    func getTagName() -> String? {
        return data.tagName
    }
}

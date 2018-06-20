//
//  Comment.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase

/**
    Structure for Comments
 */

struct CommentStruct {
    var reference: String?
    var parentRef: String?
    var replyRef: String?
    var replyCount: Int?
    var author: UserProfile?
    var content: String?
    var time: String?
}



/**
    The object used for managing comments.
 
    - field data: the variable used for saving the comment data.
 */

class Comment{
    
    private var data: CommentStruct!
    
    
    /**
     
     Initializer which create empty comment struct for comment/reply.
     
     - parameter authorID: uid of author
     
     - parameter parentRef: reference of data containing this comment
     
     */
    
    init(authorID: String, parentRef: String) {
        data = CommentStruct()
        data.author = UserProfile(uid: authorID)
        data.parentRef = parentRef
    }
    
    
    
    
    
    /**
     
     Initializer which will parse online data for comment structure.
     
     - parameter reference: reference of this comment in database.
     
     */
    
    init(reference: String){
        data = CommentStruct()
        data.reference = reference
    }
    
    

    
    /**
     
     Set the content of this comment.
     
     - parameter content: the content need to be stored.
     
     */
    
    func setContent(content: String){
        data.content = content
    }
    
    
    
    
    
    
    // Getters
    
    func getReference() -> String? {
        return data.reference
    }
    
    func getParentRef() -> String? {
        return data.parentRef
    }
    
    func getReplyRef() -> String? {
        return data.replyRef
    }
    
    func getReplyCount() -> Int? {
        return data.replyCount
    }
    
    func getAuthor() -> UserProfile? {
        return data.author
    }
    
    func getContent() -> String? {
        return data.content
    }
    
    func getTime() -> String? {
        return data.time
    }
    
    
    
    
    
    
    /**
     
     Generate a JSON file based on the comment data for uploading.
     
     */
    
    func toJSON() -> [String: Any] {
        return ["reference": (data.reference ?? "") as Any,
                "parentRef": (data.parentRef ?? "") as Any,
                "replyRef": (data.replyRef ?? "") as Any,
                "replyCount": (data.replyCount ?? "") as Any,
                "author": (data.author?.getUID() ?? "") as Any,
                "content": (data.content ?? "") as Any]
    }
    
    
    
    
    
    
    
    
    /**
        Upload comment to the server asynchronously.
     
        - parameter Anonymously: TRUE if the user want to hide his name, FALSE otherwise.
     
        - parameter vc: An UIAlertView will be shown on the given UIViewController if there is an error during the uploading process.
     
        - parameteer completion: The closure that will be excuted after uploading finishes.
     */
    
    func upload(completion: @escaping (String?, DatabaseReference?)->Void) {
        
    }
    
}

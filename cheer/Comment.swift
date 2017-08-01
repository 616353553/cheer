//
//  Comment.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

/**
    Structure for Comments
 */

struct CommentStruct {
    var commentType: CommentType
    var uid: String
    var directory: String
    var recipient: UserPortfolio?
    var content: String
    var time: Date
    var replyCount: Int?
}


enum CommentType: String {
    case comment = "comment"
    case reply = "reply"
}




/**
    The object used for managing comments.
 
    - field data: the variable used for saving the comment data.
 */

class Comment{
    
    private var data: CommentStruct!
    private let timeFormatter = DateFormatter()
    
    
    
    
    /**
     
     Initializer which create empty comment struct for comment/reply.
     
     - parameter commentType: comment type.

     - comment: For comment.
     
     - reply: For reply.
     
     - parameter directory: Target directory
     
     - parameter recipientID: User whom is replied to.
     
     */
    
    func initialize(commentType: CommentType, directory: String, recipientID: String?) {
        guard Auth.auth().currentUser != nil else {
            fatalError("Error: user must be signed in to comment/reply")
        }
        data = CommentStruct(commentType: commentType,
                             uid: Auth.auth().currentUser!.uid,
                             directory: directory,
                             recipient: nil,
                             content: "",
                             time: Date(),
                             replyCount: nil)
        switch commentType {
        case .comment:
            break
        case .reply:
            data.recipient = UserPortfolio()
            data.recipient!.initialize(uid: recipientID!)
        }
    }
    
    
    
    
    
    /**
     
     Initializer which will parse online data for comment structure.
     
     - parameter commentData: data which downloaded from server.
     
     */
    
    func initialize(commentData: [String: AnyObject]){
        
        timeFormatter.locale = Config.locale
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm Z"
        
        data = CommentStruct(commentType: .comment,
                             uid: "",
                             directory: "",
                             recipient: nil,
                             content: "",
                             time: Date(),
                             replyCount: nil)
        
        // comment type
        // set default value
        data.commentType = .comment
        if let commentTypeString = commentData["commentType"] as? String {
            if let commentType = CommentType(rawValue: commentTypeString) {
                data.commentType = commentType
            }
        }
        
        // user ID
        if let uid = commentData["uid"] as? String {
            data.uid = uid
        }
        
        // replies list directory / comment list directory (Based on comment type)
        switch data.commentType {
        case .comment:
            if let repliesListDirectory = commentData["replyList"] as? String {
                data.directory = repliesListDirectory
            }
            if let replyCount = commentData["count"] as? Int {
                data.replyCount = replyCount
            }
        case .reply:
            if let commentsListDirectory = commentData["commentList"] as? String {
                data.directory = commentsListDirectory
            }
            data.recipient = UserPortfolio()
            // recipient
            if let recipientID = commentData["recipient"] as? String {
                data.recipient!.initialize(uid: recipientID)
            } else {
                data.recipient!.initialize(uid: "")
            }
        }
        
        // content
        if let content = commentData["content"] as? String {
            data.content = content
        }
        
        // time
        if let timeString = commentData["time"] as? String {
            if let time = timeFormatter.date(from: timeString) {
                data.time = time
            }
        }
    }
    
    

    
    
    
    
    func setCommentType(commentType: CommentType) {
        data.commentType = commentType
    }
    
    func setUID(uid: String) {
        data.uid = uid
    }
    
    func setDirectory(directory: String) {
        data.directory = directory
    }
    
    func setRecipient(recipient: UserPortfolio) {
        data.recipient = recipient
    }
    
    func setContent(content: String){
        data.content = content
    }
    
    func setTime(time: Date) {
        data.time = time
    }
    
    
    
    
    
    
    
    
    func getCommentType() -> CommentType {
        return data.commentType
    }
    
    func getUID() -> String {
        return data.uid
    }
    
    func getDirectory() -> String {
        return data.directory
    }

    func getRecipient() -> UserPortfolio? {
        return data.recipient
    }
    
    func getContent() -> String {
        return data.content
    }
    
    func getTime() -> Date {
        return data.time
    }
    
    func getReplyCount() -> Int {
        return data.replyCount!
    }
    
    
    
    
    
    
    /**
     
     Generate a JSON file based on the comment data for uploading.
     
     */
    
    func toJSON() -> [String: AnyObject] {
        guard self.data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        var jsonFile: [String: AnyObject] = ["directory": data.directory as AnyObject]
        // create JSON file
        var comment = ["commentType": data.commentType.rawValue as AnyObject,
                       "uid": data.uid as AnyObject,
                       "content": data.content as AnyObject]
        switch data.commentType {
        case .comment:
            break
        case .reply:
            if data.recipient != nil {
                comment["recipient"] = data.recipient!.getUID() as AnyObject
            } else {
                comment["recipient"] = "" as AnyObject
            }
        }
        jsonFile["data"] = comment as AnyObject
        return jsonFile
    }
    
    
    
    
    
    
    
    
    /**
        Upload comment to the server asynchronously.
     
        - parameter Anonymously: TRUE if the user want to hide his name, FALSE otherwise.
     
        - parameter vc: An UIAlertView will be shown on the given UIViewController if there is an error during the uploading process.
     
        - parameteer completion: The closure that will be excuted after uploading finishes.
     */
    
    func upload(completion: @escaping (String?, DatabaseReference?)->Void){
        var endPointString = ""
        switch data.commentType {
        case .comment:
            endPointString = "comment_upload"
        case .reply:
            endPointString = "reply_upload"
        }
        let action = NERequestAction.init(endPoint: endPointString, httpBody: toJSON()) { (data, dataBaseError, requestError) in
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

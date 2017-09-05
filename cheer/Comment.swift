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
    var parentDirectory: String?
    var directory: String?
    var childDirectory: String?
    var author: UserProfile
    var recipient: UserProfile?
    var content: String
    var time: Date?
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
     
     - parameter directory: "group directory" if comment type is ".comment"; "comment directory" if comment type is ".reply"
     
     - parameter recipientID: User whom is replied to.
     
     */
    
    func initialize(commentType: CommentType, parentDirectory: String, recipientID: String?) {
        guard Auth.auth().currentUser != nil else {
            fatalError("Error: user must be signed in to comment/reply")
        }
        data = CommentStruct(commentType: commentType,
                             parentDirectory: parentDirectory,
                             directory: nil,
                             childDirectory: nil,
                             author: UserProfile(),
                             recipient: nil,
                             content: "",
                             time: nil,
                             replyCount: nil)
        switch commentType {
        case .comment:
            break
        case .reply:
            data.recipient = UserProfile()
            data.recipient!.initialize(uid: recipientID!)
        }
        data.author.initialize(uid: Auth.auth().currentUser!.uid)
    }
    
    
    
    
    
    /**
     
     Initializer which will parse online data for comment structure.
     
     - parameter commentData: data which downloaded from server.
     
     */
    
    func initialize(commentDirectory: String, commentData: [String: AnyObject]){
        
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        data = CommentStruct(commentType: .comment,
                             parentDirectory: nil,
                             directory: commentDirectory,
                             childDirectory: "",
                             author: UserProfile(),
                             recipient: nil,
                             content: "",
                             time: Date(),
                             replyCount: 0)
        
        data.commentType = .comment
        if let commentTypeString = commentData["commentType"] as? String {
            if let commentType = CommentType(rawValue: commentTypeString) {
                data.commentType = commentType
            }
        }
        data.author.initialize(uid: (commentData["authorID"] as? String) ?? "")
        switch data.commentType {
        case .comment:
            data.childDirectory = (commentData["replyList"] as? String) ?? ""
            data.replyCount = (commentData["replyCount"] as? Int) ?? 0
        case .reply:
            data.recipient = UserProfile()
            data.recipient!.initialize(uid: (commentData["recipientID"] as? String) ?? "")
        }
        data.content = (commentData["content"] as? String) ?? ""
        
        // time
        if let timeString = commentData["createdAt"] as? String {
            if let time = timeFormatter.date(from: timeString) {
                data.time = time
            }
        }
    }
    
    

    
    
    
    
    func setCommentType(commentType: CommentType) {
        data.commentType = commentType
    }
    
    func setUID(uid: String) {
        data.author.setUID(uid: uid)
    }
    
    func setParentDirectory(parentDirectory: String?) {
        data.parentDirectory = parentDirectory
    }
    
    func setDirectory(directory: String?) {
        data.directory = directory
    }
    
    func setChildDirectory(childDirectory: String) {
        data.childDirectory = childDirectory
    }
    
    func setRecipient(recipient: UserProfile?) {
        data.recipient = recipient
    }
    
    func setContent(content: String){
        data.content = content
    }
    
    func setTime(time: Date?) {
        data.time = time
    }
    
    
    
    
    
    
    
    
    func getCommentType() -> CommentType {
        return data.commentType
    }
    
    func getAuthor() -> UserProfile {
        return data.author
    }
    
    func getParentDirectory() -> String {
        return data.parentDirectory ?? ""
    }
    
    func getDirectory() -> String {
        return data.directory ?? ""
    }
    
    func getChildDirectory() -> String {
        return data.childDirectory ?? ""
    }

    func getRecipient() -> UserProfile? {
        return data.recipient
    }
    
    func getContent() -> String {
        return data.content
    }
    
    func getTime() -> Date? {
        return data.time
    }
    
    func getTimeString() -> String? {
        let tempFormatter = DateFormatter()
        tempFormatter.locale = Config.locale
        tempFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let time = data.time {
            return tempFormatter.string(from: time)
        } else {
            return nil
        }
    }
    
    func getReplyCount() -> Int {
        return data.replyCount ?? 0
    }
    
    
    
    
    
    
    /**
     
     Generate a JSON file based on the comment data for uploading.
     
     */
    
    func toJSON() -> [String: AnyObject] {
        guard self.data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        var jsonFile: [String: AnyObject] = ["directory": (data.parentDirectory ?? "") as AnyObject]
        // create JSON file
        var comment = ["commentType": data.commentType.rawValue as AnyObject,
                       "authorID": data.author.getUID() as AnyObject,
                       "content": data.content as AnyObject]
        switch data.commentType {
        case .comment:
            break
        case .reply:
            comment["recipientID"] = (data.recipient?.getUID() ?? "") as AnyObject
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

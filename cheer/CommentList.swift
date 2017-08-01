//
//  CommentList.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/26.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentList {
    
    private var comments: [Comment]!
    private var directory: String!
    private var numOfQuery: UInt!
    private var commentType: CommentType!
    
    func initialize(directory: String, numOfQuery: UInt, commentType: CommentType) {
        self.comments = []
        self.directory = directory
        self.numOfQuery = numOfQuery
        self.commentType = commentType
    }
    
    func loadMoreIfPossible(completion: @escaping (DataSnapshot) -> Void) {
        let query = Database.database().reference().child(directory).queryLimited(toLast: numOfQuery)
        query.observe(.value, with: { (snapshot) in
            if let commentsData = snapshot.value as? [String: [String: AnyObject]] {
                for commentData in commentsData {
                    let comment = Comment()
                    comment.initialize(commentData: commentData.value)
                    self.comments.append(comment)
                }
            } else {
                // error?
            }
            completion(snapshot)
        })
        
    }
    
    
    
    /**
     
     Set maximum count of each query.
    
     - parameter numOfQuery: maximum count of each query
     
    */
    
    func setNumOfQuery(numOfQuery: UInt) {
        self.numOfQuery = numOfQuery
    }
    
    
    
    
    
    
    /**
     
     Get maximum count of each query.
     
     - returns: Maximum count of each query.
     
     */
    
    func geNumOfQuery() -> UInt {
        return self.numOfQuery
    }
    
    
    
    
    
    
    
    func getDirectory() -> String {
        return directory
    }
    
    
    
    
    
    
    
    /**
     
     Get comment at given index.
     
     - parameter atIndex: given index.
     
     - returns: comment at given index.
     
     */
    
    func getComment(atIndex index: Int) -> Comment? {
        if index < comments.count {
            return comments[index]
        }
        return nil
    }
    
    func getCommentsCount() -> Int {
        return comments.count
    }
}

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
    private var parentDirectory: String!
    private var directory: String!
    private var numOfQuery: UInt!
    private var commentType: CommentType!
    
    func initialize(parentDirectory: String, directory: String, numOfQuery: UInt, commentType: CommentType) {
        self.comments = []
        self.parentDirectory = parentDirectory
        self.directory = directory
        self.numOfQuery = numOfQuery
        self.commentType = commentType
    }
    
    func loadMoreIfPossible(cleanData: Bool, completion: @escaping (DataSnapshot) -> Void) {
        if cleanData {
            comments.removeAll()
        }
        let query = Database.database().reference().child(directory).queryLimited(toLast: numOfQuery).queryOrderedByKey()
        query.observe(.value, with: { (snapshot) in
            query.removeAllObservers()
            if let commentsData = snapshot.value as? [String: [String: AnyObject]] {
                let data = commentsData.sorted(by: { $0.0 > $1.0 })
                for commentData in data {
                    let comment = Comment()
                    comment.initialize(commentDirectory: self.directory.appending("/\(commentData.key)"), commentData: commentData.value)
                    self.comments.append(comment)
                }
            }
            completion(snapshot)
        })
    }
    
    func clear() {
        comments.removeAll()
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
    
    
    
    
    
    
    func getParentDirectory() -> String {
        return parentDirectory
    }
    
    
    
    
    
    func getDirectory() -> String {
        return directory
    }
    
    
    
    
    
    
    
    /**
     
     Get comment at given index.
     
     - parameter atIndex: given index.
     
     - returns: comment at given index.
     
     */
    
    func getComment(at index: Int) -> Comment {
        return comments[index]
    }
    
    func count() -> Int {
        return comments.count
    }
}

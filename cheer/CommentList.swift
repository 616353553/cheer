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
    
    private var commentsCount: Int!
    private var comments: [Comment]!
    private var parentRef: String!
    private var reference: String!
    
    
    
    init(parentReference: String, reference: String) {
        self.comments = []
        self.parentRef = parentReference
        self.reference = reference
    }
    
    func retrieveMoreIfPossible(completion: @escaping (DataSnapshot) -> Void) {
        let query = Database.database().reference().child(reference).queryLimited(toLast: 10).queryOrderedByKey()
        query.observe(.value, with: { (snapshot) in
            query.removeAllObservers()
            if let commentsData = snapshot.value as? [String: [String: AnyObject]] {
                let data = commentsData.sorted(by: { $0.0 > $1.0 })
                for commentData in data {
                    let comment = Comment(reference: self.reference.appending("/\(commentData.key)"))
                    self.comments.append(comment)
                }
            }
            completion(snapshot)
        })
    }
    
    
    
    func clear() {
        comments.removeAll()
    }
    
    
    
    
    // Getters
    
    func getParentRef() -> String {
        return parentRef
    }
    
    func getReference() -> String {
        return reference
    }
    
    func getCommentsCount() -> Int {
        return commentsCount
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

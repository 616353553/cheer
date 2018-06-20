//
//  School.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/3.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseStorage

class School {
    
    private var fullName: String!
    private var logoRef: String!
    private var state: String!
    private var teacherList: String!
    private var logo: UIImage?
    
    init?(fullName: String?, logoRef: String?, state: String?, teacherList: String?){
        if fullName == nil || logoRef == nil || state == nil || teacherList == nil {
            return nil
        } else {
            self.fullName = fullName
            self.logoRef = logoRef
            self.state = state
            self.teacherList = teacherList
        }
    }
    
    func getFullName() -> String {
        return self.fullName
    }
    
    func getState() -> String {
        return self.state
    }
    
    func getTeacherList() -> String {
        return self.teacherList
    }
    
    func getLogo() -> UIImage? {
        return self.logo
    }
    
    func fetchLogo(completion: @escaping (UIImage?, Error?) -> Void) {
        Storage.storage().reference().child(self.logoRef).getData(maxSize: 1024 * 1024) { (data, error) in
            if data != nil {
                self.logo = UIImage(data: data!)
            }
            completion(self.logo, error)
        }
    }
    
}

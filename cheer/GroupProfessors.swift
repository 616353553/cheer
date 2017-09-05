//
//  GroupProfessors.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class GroupProfessors {
    
    
    private var data: [String?]!
    
    
    func initialize() {
        data = [String?]()
    }
    
    
    
    
    
    func initialize(professors: [String?]) {
        data = professors
    }
    
    
    
    
    
    
    func get(at index: Int) -> String? {
        return data[index]
    }
    
    
    
    
    
    func set(at index: Int, professor: String?) {
        data[index] = professor
    }
    
    
    
    
    
    func append(professor: String?) {
        data.append(professor)
    }
    
    
    
    
    
    func remove(at index: Int) {
        data.remove(at: index)
    }
    
    
    
    
    
    
    func count() -> Int {
        return data.count
    }
    
    
    
    
    
    
    
    func isEmpty() -> Bool {
        for professor in data {
            if professor != nil && professor != "" {
                return false
            }
        }
        return true
    }
    
    
    
    
    
    
    func arrayWithoutEmpty() -> [String] {
        var result = [String]()
        for professor in data {
            if professor != nil && professor != "" {
                result.append(professor!)
            }
        }
        return result
    }
    

    
    
    
    
    
    func toString() -> String {
        var result = ""
        let nonEmptyData = arrayWithoutEmpty()
        if nonEmptyData.count > 0 {
            result = "\(nonEmptyData[0])"
            for i in 1..<nonEmptyData.count {
                result.append(", \(nonEmptyData[i])")
            }
        }
        return result
    }
}

//
//  GroupDepartments.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class GroupDepartments {

    private var data: [String?]!
    
    
    
    func initialize() {
        data = [String?]()
    }
    
    
    
    func initialize(departments: [String?]) {
        data = departments
    }
    
    
    
    
    
    func get(at index: Int) -> String? {
        return data[index]
    }
    
    
    
    
    
    func set(at index: Int, department: String?) {
        data[index] = department
    }
    
    
    
    
    
    func append(department: String?) {
        data.append(department)
    }
    
    
    
    
    
    func remove(at index: Int) {
        data.remove(at: index)
    }
    
    
    
    
    
    
    func count() -> Int {
        return data.count
    }
    
    
    
    
    
    
    
    func isEmpty() -> Bool {
        for department in data {
            if department != nil && department != "" {
                return false
            }
        }
        return true
    }
    
    
    
    
    
    
    func arrayWithoutEmpty() -> [String] {
        var result = [String]()
        for department in data {
            if department != nil && department != "" {
                result.append(department!)
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

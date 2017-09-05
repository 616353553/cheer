//
//  Report.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ReportStruct {
    var directory: String
    var reasons: [String?]
    var description: String
}

class Report {
    
    private var data: ReportStruct!
    
    func initialize(directory: String, reasonCount: Int) {
        data = ReportStruct(directory: directory, reasons: [String?](repeating: nil, count: reasonCount), description: "")
    }
    
    func setDirectory(directory: String) {
        data.directory = directory
    }
    
    func setReasons(reasons: [String?]) {
        data.reasons = reasons
    }
    
    func setDescription(description: String) {
        data.description = description
    }
    
    func getDirectory() -> String {
        return data.directory
    }
    
    func getReasons() -> [String?] {
        return data.reasons
    }
    
    func getDescription() -> String {
        return data.description
    }
    
    func isValidReport() -> String? {
        if !isEmptyReasons() {
            if data.description.characters.count < Config.reportMaxLettersAllowed {
                return nil
            } else {
                return "Description too long"
            }
        } else {
            return "Please select at least 1 report reason"
        }
    }
    
    func isEmptyReasons() -> Bool {
        for reason in data.reasons {
            if reason != nil {
                return false
            }
        }
        return true
    }
    
    func toJSON() -> [String: AnyObject] {
        var json = ["directory": data.directory as AnyObject,
                    "reasons": data.reasons as AnyObject]
        if data.description != "" {
            json["description"] = data.description as AnyObject
        }
        return json
    }
    
    func upload(completion: (String?, DataSnapshot?) -> Void) {
        print("Report upload has not been implemented yet")
        let data = toJSON()
        print(data)
    }
    
}

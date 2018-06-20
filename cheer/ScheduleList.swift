//
//  ScheduleList.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/7.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import Foundation

class ScheduleList {
    
    private var reference: String?
    private var schedules: [Schedule]!
    
    
    init() {
        self.schedules = []
    }
    
    init(reference: String) {
        self.reference = reference
        self.schedules = []
    }
    
    func retrieveData() {
        
    }
    
    subscript(index: Int) -> Schedule {
        get {
            return schedules[index]
        }
        set(newValue) {
            schedules[index] = newValue
        }
    }
    
    func count() -> Int {
        return schedules.count
    }
    
    func toString() -> String {
        var scheduleString = ""
        for (index, schedule) in schedules.enumerated() {
            if index != 0 {
                scheduleString.append("/n/n")
            }
            scheduleString.append(schedule.toString()!)
        }
        return scheduleString
    }
    
    func getJSON() -> [String: Any] {
        var schedulesJSON = [String: Any]()
        for (index, schedule) in schedules.enumerated() {
            schedulesJSON[String(index)] = schedule.toJSON()
        }
        return schedulesJSON
    }
}

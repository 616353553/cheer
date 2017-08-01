//
//  Schedule.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

struct ScheduleStruct {
    var repeating: Bool
    var repeatType: ScheduleRepeatingType?
    var frequency: [String]?
    var startDate: Date?
    var endDate: Date?
    var date: Date?
    var wholeDay: Bool
    var startTime: Date?
    var endTime: Date?
}

enum ScheduleRepeatingType {
    case repeatByDay
    case repeatByWeek
    case repeatByMonth
}

enum scheduleDataType {
    case repeating
    case repeatType
    case frequency
    case startDate
    case endDate
    case date
    case wholeDay
    case startTime
    case endTime
}

class Schedule {
    
    private var data: ScheduleStruct!
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    func initialize() {
        
        dateFormatter.locale = Config.locale
        dateFormatter.dateFormat = "MMM dd yyyy"
        timeFormatter.locale = Config.locale
        timeFormatter.dateFormat = "hh:mm a"
        
        let gregorian = Calendar(identifier: .gregorian)
        let date = Date()

        data = ScheduleStruct(repeating: false, repeatType: .repeatByDay, frequency: nil, startDate: nil, endDate: nil, date: nil, wholeDay: false, startTime: nil, endTime: nil)
        
        var dayComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dayComponents.hour = 0
        dayComponents.minute = 0
        dayComponents.second = 0
        let startDate = gregorian.date(from: dayComponents)!
        data.startDate = startDate
        data.date = startDate
        data.endDate = startDate.addingTimeInterval(60 * 60 * 24)
        
        var timeComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        timeComponents.year = 0
        timeComponents.month = 0
        timeComponents.day = 0
        timeComponents.second = 0
        let startTime = gregorian.date(from: timeComponents)!
        data.startTime = startTime
        data.endTime = startTime.addingTimeInterval(60)
    }
    
    
    
    func initialize(scheduleData: [String: AnyObject]) {
        dateFormatter.locale = Config.locale
        dateFormatter.dateFormat = "MMM dd yyyy"
        timeFormatter.locale = Config.locale
        timeFormatter.dateFormat = "hh:mm a"
        
        data = ScheduleStruct(repeating: scheduleData["repeating"] as! Bool, repeatType: .repeatByDay, frequency: nil, startDate: nil, endDate: nil, date: nil, wholeDay: scheduleData["wholeDay"] as! Bool, startTime: nil, endTime: nil)
        
        if data.repeating {
            data.startDate = dateFormatter.date(from: scheduleData["startDate"] as! String)
            data.endDate = dateFormatter.date(from: scheduleData["endDate"] as! String)
            switch scheduleData["repeatType"] as! String {
            case "repeatByDay":
                data.repeatType = .repeatByDay
            case "repeatByWeek":
                data.repeatType = .repeatByWeek
            case "repeatByMonth":
                data.repeatType = .repeatByMonth
            default:
                break
            }
            data.frequency = scheduleData["frequency"] as? [String]
        } else {
            data.date = dateFormatter.date(from: scheduleData["date"] as! String)
        }
        
        if !data.wholeDay {
            data.startTime = timeFormatter.date(from: scheduleData["startTime"] as! String)
            data.endTime = timeFormatter.date(from: scheduleData["endTime"] as! String)
        }
    }
    
    
    
    private func set(dataType: scheduleDataType, value: Any?) {
        switch dataType {
        case .repeating:
            data!.repeating = value as! Bool
        case .repeatType:
            data!.repeatType = value as! ScheduleRepeatingType?
        case .frequency:
            data!.frequency = value as! [String]?
        case .startDate:
            data!.startDate = value as! Date?
        case .endDate:
            data!.endDate = value as! Date?
        case .date:
            data!.date = value as! Date?
        case .wholeDay:
            data!.wholeDay = value as! Bool
        case .startTime:
            data!.startTime = value as! Date?
        case .endTime:
            data!.endTime = value as! Date?
        }
    }
    
    private func get(dataType: scheduleDataType) -> Any? {
        switch dataType {
        case .repeating:
            return data!.repeating as Any?
        case .repeatType:
            return data!.repeatType as Any?
        case .frequency:
            return data!.frequency as Any?
        case .startDate:
            return data!.startDate as Any?
        case .endDate:
            return data!.endDate as Any?
        case .date:
            return data!.date as Any?
        case .wholeDay:
            return data!.wholeDay as Any?
        case .startTime:
            return data!.startTime as Any?
        case .endTime:
            return data!.endTime as Any?
        }
    }
    
    
    
    

    // setters
    
    func setRepeating(repeating: Bool?) {
        set(dataType: .repeating, value: repeating)
    }
    
    func setRepeatType(repeatType: ScheduleRepeatingType?) {
        set(dataType: .repeatType, value: repeatType)
    }
    
    func setFrequency(frequency: [String]?) {
        set(dataType: .frequency, value: frequency)
    }
    
    func setStartDate(startDate: Date?) {
        set(dataType: .startDate, value: startDate)
    }
    
    func setEndDate(endDate: Date?) {
        set(dataType: .endDate, value: endDate)
    }
    
    func setDate(date: Date?) {
        set(dataType: .date, value: date)
    }
    
    func setWholeDay(wholeDay: Bool?) {
        set(dataType: .wholeDay, value: wholeDay)
    }
    
    func setStartTime(startTime: Date?) {
        set(dataType: .startTime, value: startTime)
    }
    
    func setEndTime(endTime: Date?) {
        set(dataType: .endTime, value: endTime)
    }
    
    
    
    
    
    // getters
    
    func getRepeating() -> Bool?{
        return get(dataType: .repeating) as! Bool?
    }
    
    func getRepeatType() -> ScheduleRepeatingType? {
        return get(dataType: .repeatType) as! ScheduleRepeatingType?
    }
    
    func getFrequency() -> [String]? {
        return get(dataType: .frequency) as! [String]?
    }
    
    func getStartDate() -> Date? {
        return get(dataType: .startDate) as! Date?
    }
    
    func getEndDate() -> Date? {
        return get(dataType: .endDate) as! Date?
    }
    
    func getDate() -> Date? {
        return get(dataType: .date) as! Date?
    }
    
    func getWholeDay() -> Bool? {
        return get(dataType: .wholeDay) as! Bool?
    }
    
    func getStartTime() -> Date? {
        return get(dataType: .startTime) as! Date?
    }
    
    func getEndTime() -> Date? {
        return get(dataType: .endTime) as! Date?
    }
    
    
    
    func copy() -> Schedule? {
        if data == nil {
            return nil
        } else {
            let schedule_copy = Schedule()
            schedule_copy.initialize()
            schedule_copy.setRepeating(repeating: data!.repeating)
            schedule_copy.setRepeatType(repeatType: data!.repeatType)
            schedule_copy.setFrequency(frequency: data!.frequency)
            schedule_copy.setStartDate(startDate: data!.startDate)
            schedule_copy.setEndDate(endDate: data!.endDate)
            schedule_copy.setDate(date: data!.date)
            schedule_copy.setWholeDay(wholeDay: data!.wholeDay)
            schedule_copy.setStartTime(startTime: data!.startTime)
            schedule_copy.setEndTime(endTime: data!.endTime)
            return schedule_copy
        }
    }
    
    
    
    
    func toStringArray() -> [[String]]? {
        if isValidSchedule() == nil{
            var strs: [[String]] = [["", ""], ["", "", "", ""]]
            if data.repeating {
                strs[0][0] = "For"
                strs[0][1] = frequencyToString()!
            } else {
                strs[0][0] = "On"
                strs[0][1] = dateToString()!
            }
            if data.wholeDay {
                strs[1][0] = "At"
                strs[1][1] = "anytime"
            } else {
                strs[1][0] = "From"
                strs[1][1] = startTimeToString()!
                strs[1][2] = "to"
                strs[1][3] = endTimeToString()!
            }
            return strs
        }
        return nil
    }
    
    
    func toString() -> String? {
        if isValidSchedule() == nil {
            var result = ""
            if data.repeating {
                result.append("From \(startDateToString()!) to \(endDateToString()!) \n")
                result.append("On \(frequencyToString()!) \n")
            } else {
                result.append("On \(dateToString()!) \n")
            }
            if data.wholeDay {
                result.append("At any time \n")
            } else {
                result.append("At \(startTimeToString()!) to \(endTimeToString()!)")
            }
            return result
        }
        return nil
    }
    
    
    
    func isValidDates() -> Bool {
        if data!.startDate != nil && data!.endDate != nil {
            return data!.startDate! < data!.endDate!
        } else {
            return true
        }
    }
    
    
    
    func isValidTimes() -> Bool {
        if data!.startTime != nil && data!.endTime != nil {
            return data!.startTime! < data!.endTime!
        } else {
            return true
        }
    }
    
    
    
    
    
    func isValidSchedule() -> String? {
        if data.repeating {
            if isValidDates() {
                if !data.wholeDay {
                    if isValidTimes() {
                        return nil
                    } else {
                        return "Invalid start/end time"
                    }
                } else {
                    return nil
                }
            } else {
                return "Invalid start/end date"
            }
        } else {
            if !data.wholeDay {
                if isValidTimes() {
                    return nil
                } else {
                    return "Invalid start/end time"
                }
            } else {
                return nil
            }
        }
    }
    
    
    
    
    
    
    func dateToString() -> String? {
        if data!.date != nil {
            return dateFormatter.string(from: data!.date!)
        }
        return nil
    }
    
    func startDateToString() -> String? {
        if data!.startDate != nil {
            return dateFormatter.string(from: data!.startDate!)
        }
        return nil
    }
    
    func endDateToString() -> String? {
        if data!.endDate != nil {
            return dateFormatter.string(from: data!.endDate!)
        }
        return nil
    }
    
    func startTimeToString() -> String? {
        if data!.startTime != nil {
            return timeFormatter.string(from: data!.startTime!)
        }
        return nil
    }
    
    func endTimeToString() -> String? {
        if data!.endTime != nil {
            return timeFormatter.string(from: data!.endTime!)
        }
        return nil
    }
    
    func frequencyToString() -> String? {
        if data!.frequency != nil {
            switch data!.repeatType! {
            case .repeatByDay:
                return "every \(data!.frequency![0]) day(s)"
            case .repeatByWeek:
                return "every \(data!.frequency![0]) week(s) on \(data!.frequency![1])"
            case .repeatByMonth:
                return "every \(data!.frequency![0]) month(s) on the \(data!.frequency![1]) \(data!.frequency![2])"
            }
        }
        return nil
    }
    
    func toJSON() -> [String: AnyObject] {
        var result = ["repeating": data.repeating as AnyObject,
                      "wholeDay": data.wholeDay as AnyObject]
        
        if data.repeating {
            switch data.repeatType! {
            case .repeatByDay:
                result["repeatType"] = "repeatByDay" as AnyObject
            case .repeatByWeek:
                result["repeatType"] = "repeatByWeek" as AnyObject
            case .repeatByMonth:
                result["repeatType"] = "repeatByMonth" as AnyObject
            }
            result["frequency"] = data.frequency! as AnyObject
            result["startDate"] = dateFormatter.string(from: data.startDate!) as AnyObject
            result["endDate"] = dateFormatter.string(from: data.endDate!) as AnyObject
        } else {
            result["date"] = dateFormatter.string(from: data.date!) as AnyObject
        }
        
        if !data.wholeDay {
            result["startTime"] = timeFormatter.string(from: data.startTime!) as AnyObject
            result["endTime"] = timeFormatter.string(from: data.endTime!) as AnyObject
        }
        
        return result
    }
    
    
}

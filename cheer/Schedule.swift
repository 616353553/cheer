//
//  Schedule.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

enum ScheduleRepeatingType: String {
    case repeatByDay = "repeatByDay"
    case repeatByWeek = "repeatByWeek"
    case repeatByMonth = "repeatByMonth"
}

struct ScheduleStruct {
    var repeating: Bool
    var repeatType: ScheduleRepeatingType
    var frequency: [String]
    var startDate: Date
    var endDate: Date
    var date: Date
    var wholeDay: Bool
    var startTime: Date
    var endTime: Date
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

        data = ScheduleStruct(repeating: false,
                              repeatType: .repeatByDay,
                              frequency: ["1"],
                              startDate: Date(),
                              endDate: Date(),
                              date: Date(),
                              wholeDay: false,
                              startTime: Date(),
                              endTime: Date())
        
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
        
        data = ScheduleStruct(repeating: false,
                              repeatType: .repeatByDay,
                              frequency: ["1"],
                              startDate: Date(),
                              endDate: Date(),
                              date: Date(),
                              wholeDay: false,
                              startTime: Date(),
                              endTime: Date())
        
        if let repeating = scheduleData["repeating"] as? Bool {
            data.repeating = repeating
        }
        
        if data.repeating {
            if let repeatTypeString = scheduleData["repeatType"] as? String {
                if let repeatType = ScheduleRepeatingType.init(rawValue: repeatTypeString) {
                    data.repeatType = repeatType
                }
            }
            if let startDateString = scheduleData["startDate"] as? String {
                if let startDate = dateFormatter.date(from: startDateString) {
                    data.startDate = startDate
                }
            }
            if let endDateString = scheduleData["endDate"] as? String {
                if let endDate = dateFormatter.date(from: endDateString) {
                    data.endDate = endDate
                }
            }
            if let frequency = scheduleData["frequency"] as? [String] {
                data.frequency = frequency
            }
        } else {
            if let dateString = scheduleData["date"] as? String {
                if let date = dateFormatter.date(from: dateString) {
                    data.date = date
                }
            }
        }
        
        if let wholeDay = scheduleData["wholeDay"] as? Bool {
            data.wholeDay = wholeDay
        }
        
        if data.wholeDay == false {
            if let startTimeString = scheduleData["startTime"] as? String {
                if let startTime = timeFormatter.date(from: startTimeString) {
                    data.startTime = startTime
                }
            }
            if let endTimeString = scheduleData["endTime"] as? String {
                if let endTime = timeFormatter.date(from: endTimeString) {
                    data.endTime = endTime
                }
            }
        }
    }
    
    
    
    
    

    // setters
    
    func setRepeating(repeating: Bool) {
        data.repeating = repeating
    }
    
    func setRepeatType(repeatType: ScheduleRepeatingType) {
        data.repeatType = repeatType
    }
    
    func setFrequency(frequency: [String]) {
        data.frequency = frequency
    }
    
    func setStartDate(startDate: Date) {
        data.startDate = startDate
    }
    
    func setEndDate(endDate: Date) {
        data.endDate = endDate
    }
    
    func setDate(date: Date) {
        data.date = date
    }
    
    func setWholeDay(wholeDay: Bool) {
        data.wholeDay = wholeDay
    }
    
    func setStartTime(startTime: Date) {
        data.startTime = startTime
    }
    
    func setEndTime(endTime: Date) {
        data.endTime = endTime
    }
    
    
    
    
    
    // getters
    
    func getRepeating() -> Bool {
        return data.repeating
    }
    
    func getRepeatType() -> ScheduleRepeatingType {
        return data.repeatType
    }
    
    func getFrequency() -> [String] {
        return data.frequency
    }
    
    func getStartDate() -> Date {
        return data.startDate
    }
    
    func getEndDate() -> Date {
        return data.endDate
    }
    
    func getDate() -> Date {
        return data.date
    }
    
    func getWholeDay() -> Bool {
        return data.wholeDay
    }
    
    func getStartTime() -> Date {
        return data.startTime
    }
    
    func getEndTime() -> Date {
        return data.endTime
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
    
    

    
    
    
    func toString() -> String? {
        if isValidSchedule() == nil {
            var result = ""
            if data.repeating {
                result.append("From \(startDateToString()) to \(endDateToString()) \n")
                result.append("On \(frequencyToString()) \n")
            } else {
                result.append("On \(dateToString()) \n")
            }
            if data.wholeDay {
                result.append("At any time \n")
            } else {
                result.append("At \(startTimeToString()) to \(endTimeToString())")
            }
            return result
        }
        return nil
    }
    
    
    
    
    
    
    func toColorString() -> NSMutableAttributedString? {
        if isValidSchedule() == nil {
            let result = NSMutableAttributedString(string: "")
            if data.repeating {
                result.append(NSMutableAttributedString(string: "From", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                       NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " \(startDateToString()) ", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
                result.append(NSMutableAttributedString(string: "to", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                   NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " \(endDateToString())\n", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
                result.append(NSMutableAttributedString(string: "On", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                   NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " \(frequencyToString())\n", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
            } else {
                result.append(NSMutableAttributedString(string: "On", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                   NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " \(dateToString())\n", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
            }
            
            if data.wholeDay {
                result.append(NSMutableAttributedString(string: "At", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                   NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " any time", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
            } else {
                result.append(NSMutableAttributedString(string: "At", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                   NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " \(startTimeToString()) ", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
                result.append(NSMutableAttributedString(string: "to", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!,
                                                                                   NSForegroundColorAttributeName: Config.themeColor]))
                result.append(NSMutableAttributedString(string: " \(endTimeToString())", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14.0)!]))
            }
            return result
        }
        return nil
    }
    
    
    
    
    
    func isValidDates() -> Bool {
        return data.startDate < data.endDate
    }
    
    
    
    
    
    
    
    func isValidTimes() -> Bool {
        return data.startTime < data.endTime
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
    
    
    
    
    
    
    func dateToString() -> String {
        return dateFormatter.string(from: data.date)
    }
    
    func startDateToString() -> String {
        return dateFormatter.string(from: data.startDate)
    }
    
    func endDateToString() -> String {
        return dateFormatter.string(from: data.endDate)
    }
    
    func startTimeToString() -> String {
        return timeFormatter.string(from: data.startTime)
    }
    
    func endTimeToString() -> String {
        return timeFormatter.string(from: data.endTime)
    }
    
    func frequencyToString() -> String {
        switch data.repeatType {
        case .repeatByDay:
            return "every \(data.frequency[0]) day(s)"
        case .repeatByWeek:
            return "every \(data.frequency[0]) week(s) on \(data.frequency[1])"
        case .repeatByMonth:
            return "every \(data.frequency[0]) month(s) on the \(data.frequency[1]) \(data.frequency[2])"
        }
    }
    
    
    
    
    
    
    
    func toJSON() -> [String: AnyObject] {
        var result = ["repeating": data.repeating as AnyObject,
                      "wholeDay": data.wholeDay as AnyObject]
        
        if data.repeating {
            switch data.repeatType {
            case .repeatByDay:
                result["repeatType"] = "repeatByDay" as AnyObject
            case .repeatByWeek:
                result["repeatType"] = "repeatByWeek" as AnyObject
            case .repeatByMonth:
                result["repeatType"] = "repeatByMonth" as AnyObject
            }
            result["frequency"] = data.frequency as AnyObject
            result["startDate"] = dateFormatter.string(from: data.startDate) as AnyObject
            result["endDate"] = dateFormatter.string(from: data.endDate) as AnyObject
        } else {
            result["date"] = dateFormatter.string(from: data.date) as AnyObject
        }
        
        if !data.wholeDay {
            result["startTime"] = timeFormatter.string(from: data.startTime) as AnyObject
            result["endTime"] = timeFormatter.string(from: data.endTime) as AnyObject
        }
        
        return result
    }
    
    
}

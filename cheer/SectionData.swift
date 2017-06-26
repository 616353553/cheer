//
//  SectionData.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/22.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class SectionData{
    var week: String?
    var time: String?
    var location: String?
    var professor: String?
    var others: String?
    
    // process a parsed foundation object generated from JSON parser
    func updateDataFromFoundation(result: Any){
        if let res = result as? [String:String]{
            // completed
            week = res["meetingDay"]
            time = "\(res["meetingStart"] as! String) - \(res["meetingEnd"] as! String)"
            location = "\(res["buildingName"] as! String) \(res["roomNumber"] as! String)"
            
            // not completed
            professor = res["instructorName"]
            others = "CRN 111111"
        }
    }
    
    //var map = ["M": "Mon", "T": "Tue", "W": "Wed", "F": "Fri"]
    func transformWeekDay(concise: String){
        
    }
    
    
    // {"meetingDay":"MWF","meetingStart":"11:00 AM","meetingEnd":"11:50 AM","buildingName":"Digital Computer Laboratory","roomNumber":"1320","instructorName":"G Herman"}
}

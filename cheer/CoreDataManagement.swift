//
//  CoreDataManagement.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/12.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManagement {
    static func getSchool() -> String? {
        var schools: [School] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            schools = try context.fetch(School.fetchRequest())
            return schools.first?.schoolName
        } catch {
            return nil
        }
    }
    
    
    
    /**
    
     Update school name if possible
     
     - parameter schoolName: the new school name to be stored in core data.
     
     - returns: Error string if there is any.
     
    */
    
    
    static func updateSchool(schoolName: String?) -> String? {
        var schools: [School] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            schools = try context.fetch(School.fetchRequest())
            if schools.count > 0 {
                schools.first?.schoolName = schoolName
            } else {
                let school = School(context: context)
                school.schoolName = schoolName
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}

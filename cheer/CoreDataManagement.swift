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
        var userDatas: [UserData] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            userDatas = try context.fetch(UserData.fetchRequest())
            return userDatas.first?.currentSchool
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
        var userDatas: [UserData] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            userDatas = try context.fetch(UserData.fetchRequest())
            if userDatas.count > 0 {
                userDatas.first?.currentSchool = schoolName
            } else {
                let userData = UserData(context: context)
                userData.currentSchool = schoolName
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}

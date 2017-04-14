//
//  Item.swift
//  cheer
//
//  Created by bainingshuo on 16/10/14.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class Item {
    var userId: String!
    var category: String!
    var deliveryMethod: String!
    var title: String!
    var price: String!
    var discription: String!
    var location: String!
    var images: ImageData!
    
    func initialize(){
        userId = FIRAuth.auth()!.currentUser!.uid
        category = "Auto"
        deliveryMethod = "Deliver"
        title = ""
        price = ""
        discription = ""
        location = UserDefaults.standard.string(forKey: "selectedSchool")!
        images = ImageData()
        images.initialize(image: #imageLiteral(resourceName: "add_image"))
    }
    
//    func upload() -> Bool{
//        var imageIds = [String]()
//        var success = [Int](repeating: 0, count: images.numOfImages)
//        
//        let date = Date()
//        let calendar = Calendar.current
//        let timezone = calendar.component(.timeZone, from: date)
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minute = calendar.component(.minute, from: date)
//        let second = calendar.component(.second, from: date)
//        let nanosecond = calendar.component(.nanosecond, from: date)
//        
//        let storageRef = FIRStorage.storage().reference()
//        for i in 0..<images.numOfImages{
//            let imageId = "Item/\(userId)/\(year)/\(timezone)/\(month)\(day)\(hour)\(minute)\(second)\(nanosecond)\(i).png"
//            storageRef.child("Items").child(location).child(imageId)
//            if let uploadData = UIImagePNGRepresentation(images.images[i]!){
//                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
//                    if error != nil {
//                        success[i] = -1
//                    }else{
//                        imageIds.append(imageId)
//                        success[i] = 1
//                    }
//                })
//            }
//            else{
//                success[i] = -1
//            }
//        }
//        
//        outerloop: while true{
//            var counter = 0
//            for status in success{
//                if status == -1{
//                    return false
//                }else{
//                    counter = counter + status
//                }
//            }
//            if counter == images.numOfImages{
//                let item: [String: AnyObject] = ["userId": userId as AnyObject,
//                                                 "category": category as AnyObject,
//                                                 "deliveryMethod": deliveryMethod as AnyObject,
//                                                 "title": title as AnyObject,
//                                                 "price": price as AnyObject,
//                                                 "discription": discription as AnyObject,
//                                                 "numOfImages": images.numOfImages as AnyObject,
//                                                 "imageIds": imageIds as AnyObject]
//                let databaseRef = FIRDatabase.database().reference()
//                databaseRef.child("Items").child(location).childByAutoId().setValue(item, withCompletionBlock: { (error, ref) in
//                    if error != nil{
//                        return false
//                    }
//                    else{
//                        return true
//                    }
//                })
//            }
//        }
//    }
}

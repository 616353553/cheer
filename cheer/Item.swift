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
        userId = Auth.auth().currentUser!.uid
        category = "Auto"
        deliveryMethod = "Deliver"
        title = ""
        price = ""
        discription = ""
        location = UserDefaults.standard.string(forKey: "selectedSchool")!
        images = ImageData()
        images.initialize()
    }
    
    func initialize(snapshot: DataSnapshot){
//        let data = snapshot.value! as! [String: Any]
//        userId = data["userId"] as! String
//        category = data["category"] as! String
//        deliveryMethod = data["deliveryMethod"] as! String
//        title = data["title"] as! String
//        price = data["price"] as! String
//        discription = data["discription"] as! String
//        images = ImageData()
//        images.initialize()
//        images.numOfImages = data["numOfImages"] as! Int
//        images.initialize(with: data["imageIds"] as! [String])
    }
    
    func upload(completion: @escaping ((Bool, String?) -> Void)){
//        for i in 0..<images.numOfImages{
//            images.imageIds[i] = "\(location!)/Items/\(UUID().uuidString).jpg"
//        }
//        FirebaseUpload.upload(item: self, completion: completion)
    }
}

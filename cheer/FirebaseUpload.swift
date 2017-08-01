//
//  FirebaseUpload.swift
//  cheer
//
//  Created by bainingshuo on 2017/4/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class FirebaseUpload{
    
    // upload the text part of an item
    static func upload(textData item: Item, completion: @escaping ((Bool, String?)->Void)){
        let itemData: [String: AnyObject] = ["userId": item.userId as AnyObject,
                                             "category": item.category as AnyObject,
                                             "deliveryMethod": item.deliveryMethod as AnyObject,
                                             "title": item.title as AnyObject,
                                             "price": item.price as AnyObject,
                                             "discription": item.discription as AnyObject,
                                             "numOfImages": item.images.numOfImages as AnyObject,
                                             "imageIds": item.images.numOfImages() as AnyObject]
        let databaseRef = Database.database().reference()
        databaseRef.child(item.location).child("Items").childByAutoId().setValue(itemData, withCompletionBlock: {(error, ref) in
            DispatchQueue.main.async{
                completion(error == nil, error?.localizedDescription)
            }
        })
    }
    
    
    
    
    
    
    
    /**
     
     Uploading one image to FireBase storage asynchronously.
     
     - parameter image: The image need to be uploaded.
     
     - parameter directory: The directory of the image.
     
     - parameter completion: The block which will be excuted after uploading processes finishes.
     
     */
    static func upload(image: UIImage, directory: String, maxSizeInByte: Int, completion: @escaping ((_ metaData: StorageMetadata?, _ errorString: String?)->Void)){
        let storageRef = Storage.storage().reference()
        print(maxSizeInByte)
        if let photoData = Compress.compress(image: image, targetSizeInByte: maxSizeInByte){
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            storageRef.child(directory).putData(photoData, metadata: metaData){ (metaData, error) in
                completion(metaData, error?.localizedDescription)
            }
        }else{
            completion(nil, "Cannot convert image to JPG format")
        }
    }
    
    
    
    
    
    
    
    
    /**
     
     Uploading images to FireBase storage asynchronously.
     
     - parameter images: The images need to be uploaded.
     
     - parameter directories: The directories of each images.
     
     - parameter completion: The block which will be excuted once all the images uploading processes finish.

     */
    static func upload(images: [UIImage?], directories: [String?], maxSizeInByte: [Int], completion: @escaping ((_ metaData: [StorageMetadata?]?, _ errors: [String?]?)->Void)){
        
        // error
        var errorStrings: [String?]? = [String?](repeating: nil, count: images.count)
        var errorCounter = 0
        
        // metadata
        var metaDatas: [StorageMetadata?]? = [StorageMetadata?](repeating: nil, count: images.count)
        var metaDataCounter = 0
        
        // pending tasks counter
        var _pendingTasks = images.count
        var pendingTasks: Int{
            set(newValue){
                _pendingTasks = newValue
                if _pendingTasks == 0 {
                    if errorCounter == 0{
                        errorStrings = nil
                    }
                    if metaDataCounter == 0{
                        metaDatas = nil
                    }
                    completion(metaDatas, errorStrings)
                }
            } get {
                return _pendingTasks
            }
        }
        
        //upload images
        for i in 0..<images.count{
            if images[i] != nil && directories[i] != nil {
                upload(image: images[i]!, directory: directories[i]!, maxSizeInByte: maxSizeInByte[i]) {(metaData, error) in
                    errorStrings?[i] = error
                    metaDatas?[i] = metaData
                    Lock.lock(object: pendingTasks as AnyObject){
                        if metaData != nil{
                            metaDataCounter = metaDataCounter + 1
                        }
                        if error != nil{
                            errorCounter = errorCounter + 1
                        }
                        pendingTasks = pendingTasks - 1
                    }
                }
            } else {
                Lock.lock(object: pendingTasks as AnyObject) {
                    pendingTasks = pendingTasks - 1
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    //upload Item for market
    static func upload(item: Item, completion: @escaping ((Bool, String?)->Void)){
        /**
        if item.images.numOfImages() != 0{
            item.images.upload(maxSizeInByte: []) { (metaData, errors) in
                if errors == nil{
                    upload(textData: item, completion: completion)
                } else {
                    for error in errors!{
                        if error != nil{
                            DispatchQueue.main.async{
                                completion(false, error)
                            }
                            break
                        }
                    }
                }
            }
        }else{
            upload(textData: item, completion: completion)
        }
         */
    }
}

//
//  ImageData.swift
//  cheer
//
//  Created by bainingshuo on 16/10/16.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import Foundation
import Photos
import FirebaseStorage



private struct imageDataStruct{
    var images: [UIImage?]?
    var directories: [String?]?
    var numOfImages: Int?
}

class ImageData{
    
    private var data: imageDataStruct?
    
    // Default capacity of allowed images.
    private let defaultCapacity = 9
    
    /**
     
     Initializer for ImageData which will create a structure with capacity of 9 nil UIImage.
     
     */
    func initialize(){
        data = imageDataStruct()
        data!.images = [UIImage?](repeating: nil, count: defaultCapacity)
        data!.directories = [String?](repeating: nil, count: defaultCapacity)
        data!.numOfImages = 0
    }
    
    
    
    
    
    /**
     
     Initializer for ImageData.
     
     - parameter size: The custom defauly capacity of allowed images.
     
     */
    func initialize(withCapacity capacity: Int){
        data = imageDataStruct()
        data!.images = [UIImage?](repeating: nil, count: capacity)
        data!.directories = [String?](repeating: nil, count: capacity)
        data!.numOfImages = 0
    }
    
    
    
    
    
    /**
     
     Initializer for ImageData.
     
     - parameter imageIds: The directory of images on Firebase.
     
     */
    func initialize(withDirectories directories: [String?]){
        data = imageDataStruct()
        data!.directories = directories
        data!.numOfImages = directories.count
        data!.images = [UIImage?](repeating: nil, count: directories.count)
    }
    
    
    
    
    
    /**
     
     Parsing UIImage(s) from PHAsset(s) asynchronously. Warning: Try to use lock on the ImageData object during this process, or the app might crash during uploading process.
     
     - parameter index: The starting index.
     
     - parameter assets: The assets which need to be parsed and appended to the data.
     
     - parameter completion: The block which will be excuted once all the parsing processes finish.
     
     */
    func setImages(startAtIndex index: Int, assets: [PHAsset], completion: @escaping (()->Void)){
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        let requestImagesQueue = DispatchQueue(label: "requestImages", attributes: .concurrent)
        for i in 0..<assets.count {
            requestImagesQueue.async {
                manager.requestImage(for: assets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option){(result, info)->Void in
                    guard result != nil else {
                        fatalError("Error: Cannot parse asset at index: \(index)")
                    }
                    self.setImage(atIndex: index + i, image: result!)
                }
            }
        }
        // wait until all image parsing processes are done, and then excute given block
        requestImagesQueue.async(flags: .barrier){
            completion()
        }

    }
    
    
    
    
    
    /**
     
     Set images to the data.
     
     - parameter index: The starting index.
     
     - parameter fromImages: The images which need to appended to the data.
     
     - parameter completion: The block which will be excuted after appending process finishes.
     
     */
    func setImages(startAtIndex index: Int, images: [UIImage?]) {
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        for i in 0..<images.count {
            self.setImage(atIndex: index + i, image: images[i])
        }
    }
    
    
    
    
    
    /**
     
     Replace image with new image at target index.
     
     - parameter index: The target index.
     
     - parameter image: The new image.
     
     */
    func setImage(atIndex index: Int, image: UIImage?){
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        if data!.images![index] == nil && image != nil {
            data!.numOfImages = data!.numOfImages! + 1
        }
        else if data!.images![index] != nil && image == nil {
            data!.numOfImages = data!.numOfImages! - 1
        }
        data!.images![index] = image
    }
    
    
    
    
    
    /**
     
     Retrieve image with at target index.
     
     - parameter index: The target index.
     
     */
    func getImage(atIndex index: Int) -> UIImage?{
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        return data!.images![index]
    }
    
    
    
    
    
    /**
     
     Replace image with asset at target index asynchronously.
     
     - parameter index: The target index.
     
     - parameter asset: The new image in PHAsset format.
     
     - parameter completion: The block which will be excuted once parsing process is done.
     
     */
    func setImage(atIndex index: Int, asset: PHAsset?, completion: @escaping (UIImage?) -> Void){
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        if asset != nil{
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = false
            
            manager.requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option){(result, info)->Void in
                self.setImage(atIndex: index, image: result)
                DispatchQueue.main.async{
                    completion(result)
                }
            }
        }
    }
    
    
    
    
    
    /**
     
     Remove image from ImageData at given index, the data structure will shrink but keep the capacity.
     
     - parameter index: The target index.
     
     */
    func removeImage(atIndex index: Int) -> UIImage?{
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        if data!.images![index] != nil {
            data!.numOfImages = data!.numOfImages! - 1
        }
        data!.images!.append(nil)
        return data!.images!.remove(at: index)
    }
    
    
    
    
    
    /**
     
     Get the number of images.
     
     - returns: The number of images in total.
     
     */
    func numOfImages()->Int{
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        return data!.numOfImages!
    }
    
    
    
    
    
    
    
    
    /**
     
     Get the directories of images.
     
     - returns: The directories of images in Firebase storage.
     
     */
    func getDirectories()->[String?]{
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        return data!.directories!
    }
    
    
    
    
    
    
    
    
    
    func retrieveImage(atIndex index: Int, completion: @escaping (UIImage?, Error?)->Void, progress: ((StorageTaskSnapshot)->Void)?, success: ((StorageTaskSnapshot)->Void)?, failure: ((StorageTaskSnapshot)->Void)?) {
        guard data!.directories != nil else {
            fatalError("Error: directory is nil")
        }
        guard data!.images![index] == nil else {
            completion(data!.images?[index], nil)
            return
        }
        let ref = Storage.storage().reference()
        let task = ref.child(data!.directories![0]!).getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
            if error == nil {
                let image = UIImage(data: data!)
                self.data!.images![index] = image
                completion(image, error)
            } else {
                completion(nil, error)
            }
        })
        if progress != nil {
            task.observe(.progress, handler: { (snapshot) in
                progress!(snapshot)
            })
        }
        if success != nil {
            task.observe(.success, handler: { (snapshot) in
                success!(snapshot)
            })
        }
        if failure != nil {
            task.observe(.failure, handler: { (snapshot) in
                failure!(snapshot)
            })
        }
    }
    
    
    
    
    
    
    
    
    /**
     
     Upload all the images to firebase.
     
     - parameter completion: The block which will be excuted after uploading process.
     
     - parameter directories: The directories of images in firebase.
     
     - parameter errors: Errors of each uploading process
     
     */
    func upload(maxSizeInByte: [Int], completion: @escaping ((_ metaData: [StorageMetadata?]?, _ errors: [String?]?) -> Void)){
        guard data != nil else {
            fatalError("Error: Object must be iniilialized before use.")
        }
        for i in 0..<data!.numOfImages!{
            if data!.directories![i] == nil{
                data!.directories![i] = UUID().uuidString
            }
        }
        FirebaseUpload.upload(images: data!.images!, directories: data!.directories!, maxSizeInByte: maxSizeInByte) {(metaData, errors) in
            completion(metaData, errors)
        }
    }
}

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



private struct imageDataStruct {
    var originalImage: UIImage?
    var originalImageRef: String?
    var thumbnailImage: UIImage?
    var thumbnailImageRef: String?
    
    init(originalImage: UIImage) {
        self.originalImage = originalImage
        self.originalImageRef = nil
        self.thumbnailImage = nil
        self.thumbnailImageRef = nil
    }
    
    init(originalImageRef: String, thumbnailImageRef: String?) {
        self.originalImage = nil
        self.originalImageRef = originalImageRef
        self.thumbnailImage = nil
        self.thumbnailImageRef = thumbnailImageRef
    }
}

class ImageData{
    
    private var data: [imageDataStruct]!
    
    /**
     
     Initializer for ImageData.
     
     */
    
    init() {
        data = []
    }
    
    init(originalRefs: [String], thumbnailRefs: [String?]) {
        data = []
        for i in 0..<originalRefs.count {
            data.append(imageDataStruct(originalImageRef: originalRefs[i], thumbnailImageRef: thumbnailRefs[i]))
        }
    }
    
    
    
    
    
    /**
     
     Parsing UIImage(s) from PHAsset(s) asynchronously. Warning: Try to use lock on the ImageData object during this process, or the app might crash during uploading process.
     
     - parameter assets: The assets which need to be parsed and appended to the data.
     
     - parameter completion: The block which will be excuted once all the parsing processes finish.
     
     */
    func appendOriginalImages(assets: [PHAsset], completion: (()->Void)?){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        let requestImagesQueue = DispatchQueue(label: "requestImages", attributes: .concurrent)
        var images = [UIImage?]()
        for i in 0..<assets.count {
            requestImagesQueue.async {
                manager.requestImage(for: assets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option){(result, info)->Void in
                    images.append(result)
                }
            }
        }
        // wait until all image parsing processes are done, and then excute given block
        requestImagesQueue.async(flags: .barrier){
            for image in images {
                if image != nil {
                    self.data.append(imageDataStruct(originalImage: image!))
                }
            }
            DispatchQueue.main.async{
                completion?()
            }
        }
    }
    
    
    
    /**
     
     Replace original image with asset at target index asynchronously.
     
     - parameter index: The target index.
     
     - parameter asset: The new image in PHAsset format.
     
     - parameter completion: The block which will be excuted once parsing process is done.
     
     */
    func setOriginalImage(at index: Int, asset: PHAsset, completion: ((UIImage?) -> Void)?){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option){(result, info)->Void in
            if result != nil {
                self.data[index].originalImage = result!
            }
            DispatchQueue.main.async{
                completion?(result)
            }
        }
    }
    
    
    
    
    
    /**
     
     Set images to the data.
     
     - parameter images: The images which need to appended to the data.
     
     */
    func appendOriginalImages(images: [UIImage]) {
        for image in images {
            self.data.append(imageDataStruct(originalImage: image))
        }
    }
    
    
    
    
    
    /**
     
     Replace originalImage with new image at target index.
     
     - parameter index: The target index.
     
     - parameter image: The new image.
     
     */
    func setOriginalImage(at index: Int, image: UIImage) {
        self.data[index].originalImage = image
    }
    
    
    
    
    /**
     
     Replace thumbnailImage with new image at target index.
     
     - parameter index: The target index.
     
     - parameter image: The new image.
     
     */
    func setThumbnailImage(at index: Int, image: UIImage) {
        self.data[index].thumbnailImage = image
    }
    
    
    
    
    
    /**
     
     Retrieve original image with at target index.
     
     - parameter index: The target index.
     
     */
    func getOriginalImage(at index: Int) -> UIImage? {
        return self.data[index].originalImage
    }
    
    
    
    
    
    /**
     
     Retrieve thumbnail image with at target index.
     
     - parameter index: The target index.
     
     */
    func getThumbnailImage(at index: Int) -> UIImage? {
        return self.data[index].thumbnailImage
    }
    
    
    
    
    
    
    /**
     
     Remove image from ImageData at given index, the data structure will shrink but keep the capacity.
     
     - parameter index: The target index.
     
     */
    func removeData(at index: Int) {
        self.data.remove(at: index)
    }
    
    
    
    
    
    /**
     
     Get the number of images.
     
     - returns: The number of images in total.
     
     */
    func numOfImages()->Int{
        return data.count
    }
    
    
    
    func retrieveThumbnailImage(at index: Int, completion: @escaping (UIImage?, Error?)->Void) {
        if let reference = self.data[index].thumbnailImageRef {
            Storage.storage().reference().child(reference).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                var image: UIImage? = nil
                if data != nil {
                    image = UIImage(data: data!)
                    self.data[index].thumbnailImage = image
                }
                DispatchQueue.main.async{
                    completion(image, error)
                }
            })
        }
    }

    
    
    
    func retrieveOriginalImage(at index: Int, completion: @escaping (UIImage?, Error?)->Void, progress: ((StorageTaskSnapshot)->Void)?, success: ((StorageTaskSnapshot)->Void)?, failure: ((StorageTaskSnapshot)->Void)?) {

        let ref = Storage.storage().reference()
        if let reference = self.data[index].originalImageRef {
            let task = ref.child(reference).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                var image: UIImage? = nil
                if data != nil {
                    image = UIImage(data: data!)
                    self.data[index].originalImage = image
                }
                DispatchQueue.main.async{
                    completion(image, error)
                }
            })
            task.observe(.progress, handler: { (snapshot) in
                progress?(snapshot)
            })
            task.observe(.success, handler: { (snapshot) in
                success?(snapshot)
            })
            task.observe(.failure, handler: { (snapshot) in
                failure?(snapshot)
            })
        }
    }
}

//
//  ImageData.swift
//  cheer
//
//  Created by bainingshuo on 16/10/16.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import Foundation
import Parse
import Photos

class ImageData{
    private var images = [UIImage?](repeating: nil, count: Config.maxImagesAllowed)
    private var imageFiles = [PFFile?](repeating: nil, count: Config.maxImagesAllowed)
    private var assets = [PHAsset?](repeating: nil, count: Config.maxImagesAllowed)
    private var numOfImages = 0
    private var empty: Bool!
    
    // set properties
    internal func setUp(item: PFObject) -> Void{
        numOfImages = item["numOfImages"] as! Int
        if numOfImages > 0{
            empty = false
            for i in 0...(numOfImages - 1){
                imageFiles[i] = item["image\(i)"] as? PFFile
            }
        }
        else{
            empty = true
            numOfImages = 1
            images[0] = Config.imageHolder
            
        }
    }
    
    internal func setImageAtIndex(index: Int, image: UIImage?) -> Void{
        images[index] = image
        self.updateNumOfImages()
    }
    
    internal func setImageFileAtIndex(index: Int, imageFile: PFFile?) -> Void{
        imageFiles[index] = imageFile
        self.updateNumOfImages()
    }
    
    internal func setAssetAtIndex(index: Int, asset: PHAsset?) -> Void{
        assets[index] = asset
        self.updateNumOfImages()
    }
    
    // get properties
    internal func isEmpty() -> Bool{
        return empty
    }
    
    internal func getImageAtIndex(index: Int) -> UIImage?{
        return images[index]
    }
    
    internal func getImageFileAtIndex(index: Int) -> PFFile?{
        return imageFiles[index]
    }
    
    internal func getAssetAtIndex(index: Int) -> PHAsset?{
        return assets[index]
    }
    
    internal func getNumOfImages() -> Int{
        return numOfImages
    }
    
    internal func getNumOfAssets() -> Int{
        var counter = 0
        for i in 0...(Config.maxImagesAllowed - 1){
            if assets[i] != nil{
                counter += 1
            }
        }
        return counter
    }
    
    // edit properties
    internal func removeImageDataAtIndex(index: Int) -> Void{
        images[index] = nil
        imageFiles[index] = nil
        assets[index] = nil
        self.updateNumOfImages()
        self.compressImages()
    }
    
    internal func addAddPhotoButtonImage() -> Void{
        if numOfImages < Config.maxImagesAllowed{
            if numOfImages > 0 && images[numOfImages - 1] != nil && images[numOfImages - 1]!.isEqual(Config.addPhotoButtonImage){
                return
            }
            else{
                images[numOfImages] = Config.addPhotoButtonImage
                self.updateNumOfImages()
            }
        }
    }
    
    internal func removeAddPhotoButtonImage() -> Void{
        if images[numOfImages - 1] != nil{
            if images[numOfImages - 1]!.isEqual(Config.addPhotoButtonImage){
                images[numOfImages - 1] = nil
                self.updateNumOfImages()
            }
        }
    }
    
    internal func compressImages() -> Void{
        var imagesTemp = [UIImage?](repeating: nil, count: Config.maxImagesAllowed)
        var imageFilesTemp = [PFFile?](repeating: nil, count: Config.maxImagesAllowed)
        var assetsTemp = [PHAsset?](repeating: nil, count: Config.maxImagesAllowed)
        var counter = 0
        
        for i in 0...(Config.maxImagesAllowed - 1){
            if images[i] != nil || imageFiles[i] != nil || assets[i] != nil{
                imagesTemp[counter] = images[i]
                imageFilesTemp[counter] = imageFilesTemp[i]
                assetsTemp[counter] = assets[i]
                counter += 1
            }
        }
        images = imagesTemp
        imageFiles = imageFilesTemp
        assets = assetsTemp
    }
    
    // copy from target imageData
    internal func copy(target: ImageData) -> Void{
        self.numOfImages = target.getNumOfImages()
        self.empty = target.isEmpty()
        for i in 0...(Config.maxImagesAllowed - 1){
            self.images[i] = nil
            self.imageFiles[i] = nil
            self.assets[i] = nil
        }
        for i in 0...(numOfImages - 1){
            self.images[i] = target.getImageAtIndex(index: i)
            self.imageFiles[i] = target.getImageFileAtIndex(index: i)
            self.assets[i] = target.getAssetAtIndex(index: i)
        }
    }
    
    //private funcs
    private func updateNumOfImages() -> Void{
        var counter = 0
        for i in 0...(Config.maxImagesAllowed - 1){
            if images[i] != nil || imageFiles[i] != nil || assets[i] != nil{
                counter += 1
            }
        }
        numOfImages = counter
        if numOfImages == 0 || (numOfImages == 1 && images[0] != nil && images[0]!.isEqual(Config.imageHolder)){
            self.empty = true
        }
        else{
            self.empty = false
        }
    }
}

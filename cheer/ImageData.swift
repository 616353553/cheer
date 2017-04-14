//
//  ImageData.swift
//  cheer
//
//  Created by bainingshuo on 16/10/16.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import Foundation
import Photos

class ImageData{
    var images: [UIImage?]!
    var numOfImages: Int!
    
    func initialize(){
        images = [UIImage?](repeating: nil, count: Config.maxImagesAllowed)
        numOfImages = 0
    }
    
    func initialize(image: UIImage){
        images = [UIImage?](repeating: image, count: Config.maxImagesAllowed)
        numOfImages = 0
    }
    
    func appendImages(from assets: [PHAsset?]?){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        if assets != nil{
            for asset in assets!{
                if asset != nil{
                    manager.requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                        self.images[self.numOfImages] = result!
                        self.numOfImages = self.numOfImages + 1
                    })
                }else{
                    break
                }
            }
        }
    }
    
    func removeImage(atIndex index: Int){
        images.remove(at: index)
        images.append(#imageLiteral(resourceName: "add_image"))
        numOfImages = numOfImages - 1
    }
    
    
}

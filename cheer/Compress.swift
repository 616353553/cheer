//
//  Compress.swift
//  cheer
//
//  Created by bainingshuo on 2017/4/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class Compress {
    static func compress(image: UIImage, targetSizeInByte: Int) -> Data?{
        var width: CGFloat = 1280
        let scale = image.size.height/image.size.width
        var data = UIImageJPEGRepresentation(reduceImageSize(image: image, width: width, height: width * scale), 0.5) as NSData?
        while data != nil && data!.length > targetSizeInByte {
            width = width - 320
            data = UIImageJPEGRepresentation(reduceImageSize(image: image, width: width, height: width * scale), 0.5) as NSData?
        }
        return data as Data?
    }
    
    static func reduceImageSize(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        image.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

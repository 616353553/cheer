//
//  Media.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation


// video option is implemeted yet
public enum MediaMemeType: String {
    case jpg = "image/jpeg"
    case png = "image/png"
    case video = "mp4"
}


struct Media {
    let filename: String
    let data: Data
    let mimeType: MediaMemeType
    
    
    init?(filename: String? = nil, data: Any, mimeType: MediaMemeType) {
        if filename == nil {
            switch mimeType {
            case .jpg:
                self.filename = "\(UUID().uuidString).jpg"
            case .png:
                self.filename = "\(UUID().uuidString).png"
            case .video:
                self.filename = "\(UUID().uuidString).mp4"
            }
        } else {
            self.filename = filename!
        }
        switch mimeType {
        case .jpg:
            guard let data = UIImageJPEGRepresentation(data as! UIImage, 0.7) else {
                return nil
            }
            self.data = data
        case .png:
            if let data = UIImagePNGRepresentation(data as! UIImage) {
                self.data = data
            } else {
                return nil
            }
        case .video:
            return nil
        }
        self.mimeType = mimeType
    }
}

//
//  Item.swift
//  cheer
//
//  Created by bainingshuo on 16/10/14.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var userID: String?
    var category: String?
    var deliveryMethod: String?
    var title: String?
    var price: String?
    var discription: String?
    var location: String?
    var numOfImages: Int?
    var images = [UIImage?](repeating: nil, count: Config.maxImagesAllowed)
}

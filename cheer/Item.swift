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
    var isForSale: Bool?
    var title: String?
    var price: Double?
    var discription: String?
    var location: String?
    var numOfContacts: Int!
    var contactMethods = [String?](repeating: nil, count: Config.maxContactsAllowed)
    var contacts = [String?](repeating: nil, count: Config.maxContactsAllowed)
    var numOfImages: Int!
    var images = [UIImage?](repeating: nil, count: Config.maxImagesAllowed)
}

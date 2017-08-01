//
//  Lock.swift
//  cheer
//
//  Created by bainingshuo on 2017/4/16.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class Lock{
    static func lock(object: AnyObject, block: () -> ()){
        objc_sync_enter(object)
        block()
        objc_sync_exit(object)
    }
}

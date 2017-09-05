//
//  ChooseSchoolTableViewController.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/12.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class ChooseSchoolTableViewController {
    
    private var vc: ChooseSchoolTVC!
    
    func initialize(delegate: ChooseSchoolTVCDelegate) {
        let storyboard = UIStoryboard.init(name: "ChooseSchool", bundle: nil)
        vc = storyboard.instantiateInitialViewController() as! ChooseSchoolTVC
        vc.delegate = delegate
    }
    
    func presentOnNavigationController(navigationController: UINavigationController) {
        guard vc != nil else {
            fatalError("Error: ChooseSchoolTableViewController must be initialized before using")
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

//
//  CommentViewController.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class CommentViewController {
    
    var vc: CommentMainTVC!
    var comments: CommentList!
    
    func initialize(comments: CommentList) {
        let storyboard = UIStoryboard.init(name: "Comment", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CommentMainTVC") as! CommentMainTVC
        vc.comments = comments
    }
    
    func presentOnNavigationController(navigationController: UINavigationController) {
        guard vc != nil else {
            fatalError("Error: CommentViewController must be initialized before using")
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func presentFromBottom(viewController: UIViewController, completion: (() -> Void)?) {
        guard vc != nil else {
            fatalError("Error: CommentViewController must be initialized before using")
        }
        viewController.present(vc, animated: true, completion: completion)
    }
}

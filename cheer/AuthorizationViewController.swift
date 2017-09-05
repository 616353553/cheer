//
//  AuthorizationViewController.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation



protocol AuthorizationViewControllerDelegate {
    func authorizationViewControllerWillDisappear()
}



/**
 Types of sign in view controllers
 
 - regular: Sign in during the use of app. (Navigation bar will show, "continue as tourist" button will hide, and no school needed to be choose after sign in/up.)
 
 - firstTime: First time use this app. ("Continue as tourist" button will show, navigation bar will hide, and the user will be asked to choose a school.)
 */

public enum AuthType {
    case regular
    case firstTime
}


class AuthorizationViewController {
    
    private var vc: AuthorizationNVC!
    
    func initialize(authType: AuthType, delegate: AuthorizationViewControllerDelegate) {
        print("AA")
        let storyboard = UIStoryboard.init(name: "Authorization", bundle: nil)
        vc = storyboard.instantiateInitialViewController() as! AuthorizationNVC
        vc.setAuthType(authType: authType)
        vc.setDelegate(delegate: delegate)
        print("BB")
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

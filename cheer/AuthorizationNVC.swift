//
//  AuthorizationNVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class AuthorizationNVC: UINavigationController {

    private var authType: AuthType!
    private var authorizationViewControllerDelegate: AuthorizationViewControllerDelegate!
    
    /**
     
     Used for setting value of "authType".
     
     */
    
    func setAuthType(authType: AuthType){
        self.authType = authType
    }
    
    /**
     
     Used for getting value of "authType".
     
     */
    
    func getAuthType() -> AuthType?{
        return authType
    }
    
    
    
    func setDelegate(delegate: AuthorizationViewControllerDelegate) {
        self.authorizationViewControllerDelegate = delegate
    }
    
    
    func getDelegate() -> AuthorizationViewControllerDelegate {
        return self.authorizationViewControllerDelegate
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

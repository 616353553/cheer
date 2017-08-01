//
//  AuthorizationNVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class AuthorizationNVC: UINavigationController {

    private var authType: AuthType?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

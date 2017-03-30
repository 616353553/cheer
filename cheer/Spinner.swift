//
//  Spinner.swift
//  cheer
//
//  Created by bainingshuo on 17/2/18.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class Spinner{
    static func enableActivityIndicator(activityIndicator: UIActivityIndicatorView, vc: UIViewController, disableInteraction: Bool? = nil) -> Void{
        activityIndicator.center = vc.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        vc.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        if disableInteraction != nil && disableInteraction == true{
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    static func disableActivityIndicator(activityIndicator: UIActivityIndicatorView, enableInteraction: Bool? = nil) -> Void{
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        if enableInteraction != nil && enableInteraction == true{
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

//
//  search_navigation_controller_delegate.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class search_navigation_controller_delegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // list_view to first_view - bi-direction
        if let vc1 = fromVC as? list_view_controller{
            if let vc2 = toVC as? FirstViewController{
                return transition_manager()
            }
        }
        
        if let vc1 = toVC as? list_view_controller{
            if let vc2 = fromVC as? FirstViewController{
                return transition_manager()
            }
        }
        
        return nil
    }
}

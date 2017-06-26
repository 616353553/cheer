//
//  transition_manager.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class transition_manager: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    
    // time
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    // animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("haha")
        let container_view = transitionContext.containerView
        let from_view = transitionContext.view(forKey: .from)
        let to_view = transitionContext.view(forKey: .to)
        let from_controller = transitionContext.viewController(forKey: .from)
        let to_controller = transitionContext.viewController(forKey: .to)
        
        container_view.addSubview(from_view!)
        container_view.addSubview(to_view!)
        
        from_view?.alpha = 1.0
        to_view?.alpha = 0.0
        
        func animation(){
            from_view?.alpha = 0.0
            to_view?.alpha = 1.0
        }
        func completion(isFinished: Bool){
            transitionContext.completeTransition(true)
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animation, completion: completion(isFinished:))

        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

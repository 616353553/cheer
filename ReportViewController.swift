//
//  ReportViewController.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class ReportViewController {
    
    private var vc: ReportNVC!
    private var report: Report!
    
    
    /**
     
     Initializer for ReportViewController.
     
     - parameter directory: The directoy of the object which is being reported.
     
     - parameter reasons: A dictionary of which the keys are report reasons and values are example/description of each corresponding reason.
     
     */
    
    func initialize(directory: String, reasons: [String: String]) {
        report = Report()
        report.initialize(directory: directory, reasonCount: reasons.count)
        let storyboard = UIStoryboard.init(name: "Report", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ReportNVC") as! ReportNVC
        vc.report = report
        vc.reasons = reasons
    }
    
    func presentOnNavigationController(navigationController: UINavigationController) {
        guard vc != nil else {
            fatalError("Error: CommentViewController must be initialized before using")
        }
        let reportVC = vc.navigationController?.childViewControllers[0] as! ReportMainTVC
        navigationController.pushViewController(reportVC, animated: true)
    }
    
    
    func presentFromBottom(viewController: UIViewController, completion: (() -> Void)?) {
        guard vc != nil else {
            fatalError("Error: CommentViewController must be initialized before using")
        }
        viewController.present(vc, animated: true, completion: completion)
    }
}

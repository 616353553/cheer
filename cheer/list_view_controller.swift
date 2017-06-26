//
//  list_view_controller.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class list_view_controller: UIViewController {

    let transitionManager = transition_manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let old_frame = search_bar.frame
        func animiation(){
            search_bar.frame = CGRect(x: search_bar.frame.minX, y: 50, width: search_bar.frame.width, height: search_bar.frame.height)
        }
        func completion(finished: Bool){
            search_bar.frame = old_frame
        }
        UIView.animate(withDuration: 0.6, animations: animiation, completion: completion(finished:))

        
    }

    @IBOutlet weak var search_bar: UIView!
    
}

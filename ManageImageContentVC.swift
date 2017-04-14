//
//  ManageImageContentVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/4/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class ManageImageContentVC: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    var doubleTap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.zoomInOut))
        doubleTap.numberOfTapsRequired = 2
        scrollView.delegate = self
        scrollView.addGestureRecognizer(doubleTap)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomInOut(){
        let zoomScale = scrollView.zoomScale < 4.0 ? 4.0 : 1.0
        scrollView.setZoomScale(CGFloat(zoomScale), animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ManageImagePageVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/4/7.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class ManageImagePageVC: UIPageViewController {

    var startIndex: Int!
    var images: ImageData!
    var VCs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        for i in 0..<images.numOfImages{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageContentView") as! ManageImageContentVC
            vc.image = images.images[i]!
            VCs.append(vc)
        }
        self.setViewControllers([VCs[startIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // solve the weired black frame during the transaction at the bottom, and set the UIControl background to clear color
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIScrollView{
                view.frame =  UIScreen.main.bounds
            } else if view is UIPageControl{
                view.backgroundColor = .clear
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteIsPushed(_ sender: UIBarButtonItem) {
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //do something?
    }

}

extension ManageImagePageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = VCs.index(of: viewController)!
        if index > 0{
            return VCs[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = VCs.index(of: viewController)!
        if index + 1 < VCs.count{
            return VCs[index + 1]
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return startIndex
    }
}

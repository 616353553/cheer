//
//  ScrollViewTableViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class ScrollViewTableViewCell: UITableViewCell {

    @IBOutlet weak var adsScrollView: UIScrollView!
    @IBOutlet weak var adsPageControl: UIPageControl!
    
    var imageArray = [UIImage]()
    var scrollTimer: Timer!
    var currentPageIndex: Int!
    let timeInterval: Double = 7.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageArray = [#imageLiteral(resourceName: "scroll_1"), #imageLiteral(resourceName: "scroll_2"), #imageLiteral(resourceName: "scroll_3"), #imageLiteral(resourceName: "scroll_4"), #imageLiteral(resourceName: "scroll_5")]
        adsPageControl.numberOfPages = imageArray.count
        adsScrollView.delegate = self
        
        adsScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.contentView.frame.height)
        adsScrollView.contentSize.width =  adsScrollView.frame.width * CGFloat(imageArray.count + 2)
        for i in 0..<(imageArray.count + 2){
            let imageView = UIImageView()
            imageView.image = imageArray[(i + imageArray.count - 1) % imageArray.count]
            imageView.contentMode = .scaleAspectFill
            let xPosition = adsScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.adsScrollView.frame.width, height: self.adsScrollView.frame.height)
            adsScrollView.addSubview(imageView)
        }
        adsScrollView.setContentOffset(CGPoint.init(x: self.adsScrollView.frame.width, y: 0), animated: false)
        currentPageIndex = 1
        scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        self.contentView.bringSubview(toFront: adsPageControl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        scrollTimer.invalidate()
//    }
    
    // automatically scroll the ScrollView to the right
    func autoScroll(){
        currentPageIndex = currentPageIndex + 1
        adsScrollView.setContentOffset(CGPoint.init(x: CGFloat(currentPageIndex) * self.adsScrollView.frame.width, y: 0), animated: true)
    }
    
    // if current page is the last page, then move to the first page
    // or if current page is the first page, move to the last page
    func adjustPosition(){
        if currentPageIndex == imageArray.count + 1{
            currentPageIndex = 1
            adsScrollView.setContentOffset(CGPoint.init(x: self.adsScrollView.frame.width, y: 0), animated: false)
        }
        else if currentPageIndex == 0{
            currentPageIndex = imageArray.count
            adsScrollView.setContentOffset(CGPoint.init(x: self.adsScrollView.frame.width * CGFloat(currentPageIndex), y: 0), animated: false)
        }
//        if adsScrollView.contentOffset.x == adsScrollView.contentSize.width - adsScrollView.frame.width{
//            currentPageIndex = 1
//            adsScrollView.setContentOffset(CGPoint.init(x: self.adsScrollView.frame.width, y: 0), animated: false)
//        }
//        else if adsScrollView.contentOffset.x == 0 {
//            currentPageIndex = imageArray.count
//            adsScrollView.setContentOffset(CGPoint.init(x: self.adsScrollView.frame.width * CGFloat(currentPageIndex), y: 0), animated: false)
//        }
    }
    
}

extension ScrollViewTableViewCell: UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        adjustPosition()
        //print(adsScrollView.contentOffset)
        adsPageControl.currentPage = currentPageIndex - 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollTimer.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageIndex = Int(adsScrollView.contentOffset.x / self.adsScrollView.frame.width)
        adjustPosition()
        adsPageControl.currentPage = currentPageIndex - 1
    }
}

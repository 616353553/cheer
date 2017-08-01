//
//  ItemWithImageCell.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import Cosmos
import KDCircularProgress
import FirebaseStorage

class ItemWithImageCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likeCounts: UILabel!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var viewCounts: UILabel!
    
    var item: Item!
    var imageViews = [UIImageView]()
    var progressViews = [KDCircularProgress]()
    var currentPageIndex = 0
    var isLoadingAllImages = false
    let scrollViewWidth = UIScreen.main.bounds.size.width - 48
    let scrollViewHeight = (UIScreen.main.bounds.size.width - 48)/13 * 6
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageScrollView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imageViews = [UIImageView]()
        progressViews = [KDCircularProgress]()
        currentPageIndex = 0
        isLoadingAllImages = false
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        
    }
    
    func updateCell(){
//        imageScrollView.layer.borderColor = UIColor.black.cgColor
//        imageScrollView.layer.borderWidth = 2
//        pageControl.backgroundColor = .black
//
//        imageScrollView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
//        imageScrollView.contentSize.width = CGFloat(scrollViewWidth * CGFloat(item.images.numOfImages))
//        
//        for i in 0..<item.images.numOfImages{
//            let imageView = UIImageView()
//            imageView.frame = CGRect(x: CGFloat(i) * scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight)
//            imageView.contentMode = .scaleAspectFill
//            let progressView = KDCircularProgress()
//            progressView.frame = CGRect(x: scrollViewWidth/2 - 35, y: scrollViewHeight/2 - 35, width: 70, height: 70)
//            progressView.clockwise = true
//            progressView.startAngle = 270
//            progressView.progressThickness = 0.2
//            progressView.trackThickness = 0.3
//            progressView.glowMode = .noGlow
//            progressView.trackColor = .white
//            progressView.set(colors: .gray)
//            
//            imageView.addSubview(progressView)
//            imageScrollView.addSubview(imageView)
//            imageViews.append(imageView)
//            progressViews.append(progressView)
//        }
//
//        pageControl.numberOfPages = item.images.numOfImages
//        pageControl.currentPage = 0
//
//        // load the first 3 images, if there are at least 3 images..
//        for i in 0..<3{
//            if i < item.images.numOfImages{
//                imageViews[i].image = item.images.images[i]
//                if item.images.images[i] == nil{
//                    loadImage(index: i)
//                }else{
//                    progressViews[i].isHidden = true
//                }
//            }else{
//                break
//            }
//        }
//        // set username, title, price...
//        userName.text = item.userId
//        title.text = item.title
//        price.text = item.price
        
    }

    @IBAction func likeIsPushed(_ sender: UIButton) {
        print("like touched")
    }
    
    func loadImage(index: Int){
//        let ref = FIRStorage.storage().reference(withPath: item.images.imageIds[index])
//        let downloadTask = ref.data(withMaxSize: 1*1000*1000) {(data, error) in
//            if error == nil{
//                let image = UIImage(data: data!)
//                self.item.images.images[index] = image
//                self.imageViews[index].image = image
//                self.progressViews[index].isHidden = true
//            }
//        }
//        downloadTask.observe(.progress) {(snapshot) in
//            self.progressViews[index].angle = snapshot.progress!.fractionCompleted * 360
//        }
    }
    
    
}

extension ItemWithImageCell: UIScrollViewDelegate{
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        currentPageIndex = Int(imageScrollView.contentOffset.x/scrollViewWidth)
//        pageControl.currentPage = currentPageIndex
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if !isLoadingAllImages{
//            isLoadingAllImages = true
//            for i in 3..<Config.maxImagesAllowed{
//                if i < item.images.numOfImages{
//                    loadImage(index: i)
//                }else{
//                    break
//                }
//            }
//        }
//    }
}

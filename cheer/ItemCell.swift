//
//  ItemCell.swift
//  cheer
//
//  Created by bainingshuo on 16/10/14.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseStorage

class ItemCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingOutlet: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    var images = ImageData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        collectionView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
}

extension ItemCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("test")
        return images.numOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let itemCell = cell as! ItemCollectionViewCell
//        let ref = FIRStorage.storage().reference(withPath: images.imageIds[indexPath.row])
//        let downloadTask = ref.data(withMaxSize: 1*1000*1000) { (data, error) in
//            if error == nil{
//                itemCell.itemImage.image = UIImage(data: data!)
//                itemCell.progressView.isHidden = true
//            }
//        }
//        downloadTask.observe(.progress) {(snapshot) in
//            itemCell.progressView.angle = snapshot.progress!.fractionCompleted * 360
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellWidth = (UIScreen.main.bounds.width - 100)/3
        let collectionCellHeight = collectionCellWidth
        return CGSize.init(width: collectionCellWidth, height: collectionCellHeight)
    }
}


//
//  ItemCell.swift
//  cheer
//
//  Created by bainingshuo on 16/10/14.
//  Copyright © 2016年 Evolvement Apps. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        return images.numOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemCell = cell as! ItemCollectionViewCell
        itemCell.itemImage.image = #imageLiteral(resourceName: "TestingImage_car")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellWidth = (UIScreen.main.bounds.width - 50)/3
        let collectionCellHeight = collectionCellWidth
        return CGSize.init(width: collectionCellWidth, height: collectionCellHeight)
    }
}


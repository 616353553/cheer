//
//  HotActivitiesTableViewCell.swift
//  cheer
//
//  Created by bainingshuo on 17/2/2.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class HotActivitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categaoryTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func moreButtonIsPushed(_ sender: Any) {
        print("'More>' is Pushed")
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HotActivitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
}

extension HotActivitiesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HotActivitiesCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemCell = cell as! HotActivitiesCollectionViewCell
        itemCell.activityImage.image = #imageLiteral(resourceName: "TestingImage_car")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellWidth = (UIScreen.main.bounds.width - 40)/2
        let collectionCellHeight = 0.85 * collectionCellWidth
        return CGSize.init(width: collectionCellWidth, height: collectionCellHeight)
    }
}

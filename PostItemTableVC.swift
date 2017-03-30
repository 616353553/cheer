//
//  PostItemTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class PostItemTableVC: UITableViewController {

    @IBOutlet weak var collegeIcon: UIImageView!
    @IBOutlet weak var collegeName: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var deliveryCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var discriptionTextView: UITextView!
    @IBOutlet weak var numberOfLetters: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var numberOfImages: UILabel!
    
    let item = Item()
    var categoryImages = [UIImage]()
    var categoryTitles = [String]()
    var deliveryMethodImages = [UIImage]()
    var deliveryMethodSelectedImages = [UIImage]()
    var deliveryMethodTitles = [String]()
    var addPhotoImage = UIImage()
    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        categoryImages = [#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car"),#imageLiteral(resourceName: "TestingImage_car")]
        categoryTitles = ["Auto", "Book", "Clothing", "Electronics", "Food", "Furniture", "Housing", "Service"]
        deliveryMethodImages = [#imageLiteral(resourceName: "Deliver_unselected"),#imageLiteral(resourceName: "Pickup_unselected"),#imageLiteral(resourceName: "Both_unselected"),#imageLiteral(resourceName: "NotApply_unselected")]
        deliveryMethodSelectedImages = [#imageLiteral(resourceName: "Deliver_selected"), #imageLiteral(resourceName: "Pickup_selected"),#imageLiteral(resourceName: "Both_selected"), #imageLiteral(resourceName: "NotApply_selected")]
        deliveryMethodTitles = ["Deliver", "Pick up", "Both", "N/A"]
        addPhotoImage = #imageLiteral(resourceName: "add_image")
        setUpCollectionView()
        setUpTextFields()
        
        // hide the keyboard when touch outside
        NotificationCenter.default.addObserver(self, selector: #selector(PostItemTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostItemTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(PostItemTableVC.dismissKeyboard))
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.addGestureRecognizer(tap)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.removeGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func displayAlert(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        deliveryCollectionView.delegate = self
        deliveryCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    func setUpTextFields(){
        titleTextField.tag = 0
        titleTextField.returnKeyType = .done
        titleTextField.delegate = self
        priceTextField.tag = 1
        priceTextField.returnKeyType = .done
        priceTextField.delegate = self
        discriptionTextView.returnKeyType = .done
        discriptionTextView.delegate = self
    }
    
    @IBAction func PostButtonIsPushed(_ sender: UIBarButtonItem) {
        if item.category == nil{
            displayAlert(title: "Error", message: "Please select a category", vc: self)
        }
        else if item.deliveryMethod == nil{
            displayAlert(title: "Error", message: "Please select a delivery method", vc: self)
        }
        else if item.title == nil || InputChecker.onlyHasWhiteSpace(text: item.title!){
            displayAlert(title: "Error", message: "Invalid title", vc: self)
        }
        else if item.price != nil && !InputChecker.onlyHasNumber(price: item.price!){
            displayAlert(title: "Error", message: "Invalid price", vc: self)
        }
        else if item.discription == nil || InputChecker.onlyHasWhiteSpace(text: item.discription!){
            displayAlert(title: "Error", message: "Invalid item discription", vc: self)
        }
        else{
            // upload to server
        }
    }
    
    

    // MARK: - Table view delegate and data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case [0, 0]:
            return 80
        case [1, 0]:
            return (UIScreen.main.bounds.width - 100) * 0.6 + 46
        case [1, 1]:
            return 0.3 * UIScreen.main.bounds.width + 11
        case [1, 2],
             [1, 3]:
            return UITableViewAutomaticDimension
        case [1, 4]:
            return 150
        case [1, 5]:
            return UIScreen.main.bounds.width + 26
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell is pressed")
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

// MARK: - UICollectionView delegate and datasource

extension PostItemTableVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "categoriesCollectionView"{
            return 8
        }
        else if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
            return 4
        }
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        if collectionView.restorationIdentifier == "categoriesCollectionView"{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        }
        else if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deliveryMethodCell", for: indexPath) as! DeliveryMethodCollectionViewCell
        }
        else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PostImageCollectionViewCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.restorationIdentifier == "categoriesCollectionView"{
            let itemCell = cell as! CategoryCollectionViewCell
            itemCell.categoryImage.image = categoryImages[indexPath.row]
            itemCell.categoryLabel.text = categoryTitles[indexPath.row]
        }
        else if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
            let itemCell = cell as! DeliveryMethodCollectionViewCell
            itemCell.deliveryMethodImage.image = deliveryMethodImages[indexPath.row]
            itemCell.deliveryMethodLabel.text = deliveryMethodTitles[indexPath.row]
        }
        else{
            let itemCell = cell as! PostImageCollectionViewCell
            itemCell.itemImage.image = addPhotoImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionCellWidth: CGFloat
        var collectionCellHeight: CGFloat
        if collectionView.restorationIdentifier == "imageCollectionView"{
            collectionCellWidth = (UIScreen.main.bounds.width - 60)/3
            collectionCellHeight = collectionCellWidth
        }
        else{
            collectionCellWidth = (UIScreen.main.bounds.width - 100)/4
            collectionCellHeight = 1.2 * collectionCellWidth
        }
        return CGSize.init(width: collectionCellWidth, height: collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.restorationIdentifier == "categoriesCollectionView"{
            //item.category = categoryTitles[indexPath.row]
            //print(categoryTitles[indexPath.row])
        }
        else if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
            let targetCell = collectionView.cellForItem(at: indexPath) as! DeliveryMethodCollectionViewCell
            for cell in collectionView.visibleCells{
                let temp = cell as! DeliveryMethodCollectionViewCell
                temp.cellIsSelected = false
                temp.deliveryMethodImage.image = deliveryMethodImages[collectionView.indexPath(for: temp)!.row]
            }
            targetCell.deliveryMethodImage.image = deliveryMethodSelectedImages[indexPath.row]
            targetCell.cellIsSelected = true
        }
        else {
            
        }
    }
}

// hide the keyboard when hit "return" button
extension PostItemTableVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // adjust current editing textfield to the top of the screen
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0{
            self.tableView.scrollToRow(at: IndexPath.init(row: 2, section: 1), at: .top, animated: true)
        }
        if textField.tag == 1{
            self.tableView.scrollToRow(at: IndexPath.init(row: 3, section: 1), at: .top, animated: true)
        }
    }
}

extension PostItemTableVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tableView.scrollToRow(at: IndexPath.init(row: 4, section: 1), at: .top, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

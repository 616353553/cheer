//
//  PostItemTableVC.swift
//  cheer
//
//  Created by bainingshuo on 17/2/3.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import Photos
import RSKImageCropper
import QBImagePickerController

class PostItemTableVC: UITableViewController {

    @IBOutlet weak var schoolLogo: UIImageView!
    @IBOutlet weak var schoolView: UIImageView!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet var catagoryButtons: [UIButton]!
    @IBOutlet weak var deliveryCollectionView: UICollectionView!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titlePlaceHolder: UILabel!
    @IBOutlet weak var titleLength: UILabel!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var discriptionTextView: UITextView!
    @IBOutlet weak var discriptionPlaceHolder: UILabel!
    @IBOutlet weak var discriptionLength: UILabel!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var numberOfImages: UILabel!
    
    let item = Item()
    let deliveryMethodImages = [#imageLiteral(resourceName: "Deliver_unselected"),#imageLiteral(resourceName: "Pickup_unselected"),#imageLiteral(resourceName: "Both_unselected"),#imageLiteral(resourceName: "NotApply_unselected")]
    let deliveryMethodSelectedImages = [#imageLiteral(resourceName: "Deliver_selected"), #imageLiteral(resourceName: "Pickup_selected"),#imageLiteral(resourceName: "Both_selected"), #imageLiteral(resourceName: "NotApply_selected")]
    let deliveryMethodTitles = ["Deliver", "Pick up", "Both", "N/A"]
    let spinner = UIActivityIndicatorView()
    var tap: UITapGestureRecognizer!
    var imagePicker: QBImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let backButton = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(backIsPushed))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        //setup category cell
        for catagoryButton in catagoryButtons{
            catagoryButton.adjustsImageWhenHighlighted = false
            ButtonDesign.round(button: catagoryButton, color: Config.themeColor, radius: 12, borderWidth: 1)
        }
        
        setupCollectionView()
        setupTextFields()
        
        // hide the keyboard when touch outside
        NotificationCenter.default.addObserver(self, selector: #selector(PostItemTableVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostItemTableVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(PostItemTableVC.dismissKeyboard))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        setupCells()
    }
    
    @IBAction func PostButtonIsPushed(_ sender: UIBarButtonItem) {
        
        if InputChecker.onlyHasWhiteSpace(text: titleTextView.text!){
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid title", vc: self)
        }
        else if (titleTextView.text!.count > 150){
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid title length", vc: self)
        }
        else if priceTextField.text! != "" && Double(priceTextField.text!) == nil{
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid price", vc: self)
        }
        else if InputChecker.onlyHasWhiteSpace(text: discriptionTextView.text!){
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid discription", vc: self)
        }
        else if discriptionTextView.text!.count > 1500{
            Alert.displayAlertWithOneButton(title: "Error", message: "Invalid discription length", vc: self)
        }
        else{
            item.title = titleTextView.text!
            item.price = priceTextField.text! == "" ? "N/A" : String(round(100 * Double(priceTextField.text!)!)/100)
            item.discription = discriptionTextView.text!
            Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
            item.upload(){(success, error) in
                Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
                if success{
                    Alert.displayAlertWithOneButton(title: "Success", message: "Your item is post successfully" , vc: self){(action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    Alert.displayAlertWithOneButton(title: "Fail", message: error!, vc: self)
                }
            }
        }
    }
    
    @IBAction func catagoryIsPushed(_ sender: UIButton) {
        for catagoryButton in catagoryButtons{
            item.category = sender.titleLabel!.text!
            ButtonDesign.selectButton(button: catagoryButton, setSelect: catagoryButton.titleLabel!.text! == item.category!)
        }
    }
    
    func backIsPushed(){
        Alert.displayAlertWithTwoButtons(title: "Alert", message: "This action will discard all the change you have made", vc: self) {(action) in
            self.navigationController?.popViewController(animated: true)
        }
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
    
    // setup cells
    func setupCells(){
        // cell 1
        schoolName.text = item.location
        schoolLogo.image = SchoolData.schoolData[item.location!]
        schoolView.image = SchoolData.schoolData[item.location!]
        // cell 2
        for catagoryButton in catagoryButtons{
            ButtonDesign.selectButton(button: catagoryButton, setSelect: catagoryButton.titleLabel!.text! == item.category!)
        }
        //cell 3
        //cell 4
        
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        deliveryCollectionView.delegate = self
        deliveryCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    func setupTextFields(){
        titleTextView.returnKeyType = .done
        titleTextView.delegate = self
        priceTextField.returnKeyType = .done
        priceTextField.delegate = self
        discriptionTextView.returnKeyType = .done
        discriptionTextView.delegate = self
    }
    
    func numberOfImagesHasChanged(){
//        imagesCollectionView.reloadData()
//        numberOfImages.text = "\(self.item.images.numOfImages!)/\(Config.maxImagesAllowed) Images"
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }
    

    // MARK: - Table view delegate and data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath{
//        case [0, 0]:
//            return 80
//        case [1, 0]:
//            return 150
//        case [1, 1]:
//            return 0.3 * UIScreen.main.bounds.width + 11
//        case [1, 2]:
//            return 140
//        case [1, 3]:
//            return UITableViewAutomaticDimension
//        case [1, 4]:
//            return 230
//        case [1, 5]:
//            if item.images.numOfImages < 3{
//                return (UIScreen.main.bounds.width - 70)/3 + 100
//            }else if item.images.numOfImages < 6{
//                return 2*(UIScreen.main.bounds.width - 70)/3 + 110
//            }else{
//                return 3*(UIScreen.main.bounds.width - 70)/3 + 120
//            }
//        default:
//            return UITableViewAutomaticDimension
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath{
        case [0, 0]:
            performSegue(withIdentifier: "selectSchool", sender: self)
        default:
            break
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
        case "selectSchool":
            let vc = segue.destination as! PostItemChangeSchoolTableVC
            vc.delegate = self
            vc.selectedSchool = item.location!
        case "manageImages":
            let vc = segue.destination as! ManageImagePageVC
            let index = sender as! IndexPath
            vc.images = item.images
            vc.startIndex = index.row
        default:
            break
        }
    }
}

// MARK: - UICollectionView delegate and datasource

extension PostItemTableVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
//            return 4
//        }else if collectionView.restorationIdentifier == "imageCollectionView"{
//            return (item.images.numOfImages + 1) > Config.maxImagesAllowed ? Config.maxImagesAllowed : (item.images.numOfImages + 1)
//        }else{
//            return 0
//        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deliveryMethodCell", for: indexPath) as! DeliveryMethodCollectionViewCell
//            cell.deliveryMethodLabel.text = deliveryMethodTitles[indexPath.row]
//            if cell.deliveryMethodLabel.text == item.deliveryMethod!{
//                cell.deliveryMethodImage.image = deliveryMethodSelectedImages[indexPath.row]
//            }else{
//                cell.deliveryMethodImage.image = deliveryMethodImages[indexPath.row]
//            }
//            return cell
//        }
//        else if collectionView.restorationIdentifier == "imageCollectionView"{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PostImageCollectionViewCell
//            cell.delegate = self
//            cell.index = indexPath.row
//            if indexPath.row < item.images.numOfImages{
//                cell.itemImage.image = item.images.images[indexPath.row]!
//                cell.deleteButton.isHidden = false
//            }else{
//                cell.itemImage.image = #imageLiteral(resourceName: "add_image")
//                cell.deleteButton.isHidden = true
//            }
//            return cell
//        }
//        else{
//            return UICollectionViewCell()
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionCellWidth: CGFloat!
        var collectionCellHeight: CGFloat!
        if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
            collectionCellWidth = (UIScreen.main.bounds.width - 100)/4
            collectionCellHeight = 1.2 * collectionCellWidth
        }
        else if collectionView.restorationIdentifier == "imageCollectionView"{
            collectionCellWidth = (UIScreen.main.bounds.width - 70)/3
            collectionCellHeight = collectionCellWidth
        }
        return CGSize.init(width: collectionCellWidth, height: collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView.restorationIdentifier == "deliveryMethodsCollectionView"{
//            item.deliveryMethod = deliveryMethodTitles[indexPath.row]
//            let targetCell = collectionView.cellForItem(at: indexPath) as! DeliveryMethodCollectionViewCell
//            for cell in collectionView.visibleCells{
//                let temp = cell as! DeliveryMethodCollectionViewCell
//                temp.deliveryMethodImage.image = deliveryMethodImages[collectionView.indexPath(for: temp)!.row]
//            }
//            targetCell.deliveryMethodImage.image = deliveryMethodSelectedImages[indexPath.row]
//        }
//        else if collectionView.restorationIdentifier == "imageCollectionView"{
//            if indexPath.row == item.images.numOfImages{
//                imagePicker = BSImagePickerViewController()
//                imagePicker.maxNumberOfSelections = Config.maxImagesAllowed - item.images.numOfImages
//                var assets: [PHAsset?]? = [PHAsset?]()
//                bs_presentImagePickerController(imagePicker, animated: true,
//                                                select: {(asset) in assets!.append(asset)},
//                                                deselect: {(asset) in
//                                                    for i in 0..<assets!.count{
//                                                        if assets![i] == asset{
//                                                            assets!.remove(at: i)
//                                                            break
//                                                        }
//                                                    }},
//                                                cancel: {(asset) in assets = nil},
//                                                finish: {(asset) in
//                                                    Spinner.enableActivityIndicator(activityIndicator: self.spinner, vc: self, disableInteraction: true)
//                                                    self.item.images.appendImages(from: assets){
//                                                        DispatchQueue.main.sync(execute: {() in
//                                                            self.numberOfImagesHasChanged()
//                                                            Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
//                                                        })
//                                                    }},
//                                                completion: nil)
//            }else{
//                performSegue(withIdentifier: "manageImages", sender: indexPath)
//            }
//        }
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
        self.tableView.scrollToRow(at: IndexPath.init(row: 3, section: 1), at: .top, animated: true)
    }
    
    
}

extension PostItemTableVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.restorationIdentifier == "title"{
            self.tableView.scrollToRow(at: IndexPath.init(row: 2, section: 1), at: .top, animated: true)
            titlePlaceHolder.isHidden = true
        } else if textView.restorationIdentifier == "discription"{
            self.tableView.scrollToRow(at: IndexPath.init(row: 4, section: 1), at: .top, animated: true)
            discriptionPlaceHolder.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.restorationIdentifier == "title"{
            titlePlaceHolder.isHidden = textView.text != ""
            titleLength.text = "\(titleTextView.text.count)/150 Letters"
        } else if textView.restorationIdentifier == "discription"{
            discriptionPlaceHolder.isHidden = textView.text != ""
            discriptionLength.text = "\(discriptionTextView.text.count)/1500 Letters"
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.restorationIdentifier == "title"{
            titlePlaceHolder.isHidden = textView.text != ""
            titleLength.text = "\(titleTextView.text.count)/150 Letters"
        } else if textView.restorationIdentifier == "discription"{
            discriptionPlaceHolder.isHidden = textView.text != ""
            discriptionLength.text = "\(discriptionTextView.text.count)/1500 Letters"
        }
    }
    
    // end editing when done is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension PostItemTableVC: PostItemChangeSchoolTableVCDelegate, PostImageCollectionViewCellDelegate{
    func setSchoolName(name: String){
        self.item.location = name
    }
    
    func deleteImage(index: Int){
        item.images.removeData(at: index)
        numberOfImagesHasChanged()
    }
}

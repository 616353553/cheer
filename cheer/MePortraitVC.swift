//
//  MePortraitVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/13.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import RSKImageCropper
import QBImagePickerController

class MePortraitVC: UIViewController {
    
    @IBOutlet weak var portraitView: UIImageView!
    @IBAction func morePushed(_ sender: UIBarButtonItem) {
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    let spinner = UIActivityIndicatorView()
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    var userProfile: UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()
        createActionSheet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createActionSheet() {
        let selectFromLibrary = UIAlertAction(title: "Select from library", style: .default) { (action) in
            let imagePicker = QBImagePickerController()
//            imagePicker.maxNumberOfSelections = 1
//            self.bs_presentImagePickerController(imagePicker, animated: true, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
//                if assets.count == 0 {
//                    Alert.displayAlertWithOneButton(title: "Error", message: "Unknown error, please try again later", vc: self)
//                    return
//                }
//                Spinner.enableActivityIndicator(activityIndicator: self.spinner, vc: self, disableInteraction: true)
//
//                // hold the orginal image
//                let originalImage = self.userProfile.getPortrait().getImage(atIndex: 0)
//
//                self.userProfile.getPortrait().setImage(atIndex: 0, asset: assets[0], completion: { (image) in
//                    if image != nil {
//                        self.userProfile.update(completion: { (errorString) in
//                            Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
//                            if errorString != nil {
//                                // clear the changes
//                                self.userProfile.getPortrait().setImage(atIndex: 0, image: originalImage)
//                                self.userProfile.getPortrait().setImage(atIndex: 0, asset: nil, completion: nil)
//                                Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
//                            } else {
//                                DispatchQueue.main.async {
//                                    self.portraitView.image = image
//                                }
//                            }
//                        })
//                    } else {
//                        Spinner.disableActivityIndicator(activityIndicator: self.spinner, enableInteraction: true)
//                        Alert.displayAlertWithOneButton(title: "Error", message: "Unknown error, please try again later", vc: self)
//                    }
//                })
//            }, completion: nil)
        }
        
        let selectFromCamera = UIAlertAction(title: "Select from camera", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // add actions to action sheet
        actionSheet.addAction(selectFromLibrary)
        actionSheet.addAction(selectFromCamera)
        actionSheet.addAction(cancelAction)
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

extension MePortraitVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = userProfile.getPortrait().getOriginalImage(at: 0)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userProfile.getPortrait().setOriginalImage(at: 0, image: chosenImage)
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: self, disableInteraction: true)
        userProfile.update { (errorString) in
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            if errorString != nil {
                // clear all the changes
                userProfile.getPortrait().setOriginalImage(at: 0, image: originalImage!)
                Alert.displayAlertWithOneButton(title: "Error", message: errorString!, vc: self)
            } else {
                DispatchQueue.main.async {
                    self.portraitView.image = chosenImage
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

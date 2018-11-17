//
//  PerosnalInfoViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/14/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit
import MobileCoreServices

class PersonalInfoViewControlller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage]
                as! UIImage
            imageView.image = image
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(PersonalInfoViewControlller.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @IBAction func useCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = true
            func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                imagePicker.dismiss(animated: true, completion: nil)
                guard imageView.image == info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
            }
        }
        
    }
    
    
    @IBAction func useImageLibrary(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = false
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}


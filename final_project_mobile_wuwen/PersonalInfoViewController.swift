//
//  PerosnalInfoViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/14/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
///////////////////////////////////////////////////////////
//https://stackoverflow.com/questions/38046663/where-do-i-add-the-database-reference-from-firebase-on-ios
//https://firebase.google.com/docs/database/ios/read-and-write

import UIKit
import MobileCoreServices
import Firebase
//import FirebaseDatabase
class PersonalInfoViewControlller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var ref: DatabaseReference!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    var photoURL: NSURL?
    
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PersonalInfoViewControlller.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    @IBAction func verifiedButtonTapped(sender:UIButton) {
        let user = Auth.auth().currentUser
        //        print(user)
        let ref = Database.database().reference()
        //        let storageRef = Storage.storage().reference()
        
        if let user = user {
            //            let imageUrlString: String = (imageUrl?.path)!
            var finalImageUrl: String?
            guard let image = imageView.image else { return }
            guard let imageData = image.jpegData(compressionQuality: 0) else { return }
            let uploadImageRef = imageReference.child("\(user.uid).jpg")
            let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                print("UPLOAD TASK FINISHED")
                uploadImageRef.downloadURL{ (url, error) in
                    if let url=url {
                        // Get the download URL
                        finalImageUrl = url.absoluteString
                        print(finalImageUrl)
                        let userObject = [
                            "first name": self.firstNameTextField.text!,
                            "last name": self.lastNameTextField.text!,
                            "phone number": self.phoneNumField.text!,
                            "profile picture" : finalImageUrl!,
                            ] as [String:Any]
                        ref.child("users").child(user.uid).setValue(userObject, withCompletionBlock: { error, ref in
                            if error == nil {
                                self.performSegue(withIdentifier: "MainPageSegue", sender: self)
                                
                            } else {
                                // Handle the error
                            }
                        })
                    }
                    else{
                        //error
                    }
                }
                print(metadata ?? "NO METADATA")
                print(error ?? "NO ERROR")
            }
            uploadTask.observe(.progress) { (snapshot) in
                print(snapshot.progress ?? "NO MORE PROGRESS")
            }
            uploadTask.resume()
        }
    }
}

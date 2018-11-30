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
    var finalImageUrl: String?
    
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
        /////////////////////////////////////////////////////////////////////////////////////////////
        let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        let imageName = imageUrl!.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let localPath = (documentDirectory as NSString).appendingPathComponent(imageName!)
        print("IIIIIIIAMMMMMHEEEEEEEERELOOOOOOKATMEEEEEE")
        print(localPath)
        //        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //        let data = image.pngData()
        //        data.writeToFile(localPath, atomically: true)
        //
        //        let imageData = NSData(contentsOfFile: localPath)!
        photoURL = NSURL(fileURLWithPath: localPath)
        
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
                /////////////////////////////////////////////////////////////////////////////////////////////
                let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
                let imageName = imageUrl!.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let localPath = (documentDirectory as NSString).appendingPathComponent(imageName!)
                print("IIIIIIIAMMMMMHEEEEEEEERELOOOOOOKATMEEEEEE")
                print(localPath)
                //        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                //        let data = image.pngData()
                //        data.writeToFile(localPath, atomically: true)
                //
                //        let imageData = NSData(contentsOfFile: localPath)!
                photoURL = NSURL(fileURLWithPath: localPath)
                /////////////////////////////////////////////////////////////////////////////////////////////
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
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func verifiedButtonTapped(sender:UIButton) {
        let user = Auth.auth().currentUser
        //        print(user)
        let ref = Database.database().reference()
        let storageRef = Storage.storage().reference()
        
        if let user = user {
            //            let imageUrlString: String = (imageUrl?.path)!
            let localFile = photoURL
            let userRef = storageRef.child("profile_pictures/\(user.uid).jpg")
            let uploadTask = userRef.putFile(from: localFile! as URL, metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    if let url=url {
                        // Get the download URL
                        self.finalImageUrl = url.absoluteString
                    }
                    else{
                        //error
                    }
                }
            }
            let userObject = [
                "first name": firstNameTextField.text!,
                "last name": lastNameTextField.text!,
                "phone number": phoneNumField.text!,
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
    }
}

//
//  DriverInfoPageViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/30/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//
import UIKit
import Firebase
import CoreMotion

class DriverInfoPageViewController: UIViewController {
    var driver: Driver!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var destNameLabel: UILabel!
    @IBOutlet weak var distDiffLabel: UILabel!
    @IBOutlet weak var phoneField: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    lazy var motionManager = CMMotionManager()
    @IBOutlet weak var shakeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("INNNNNN DriverInfo")
        print(driver.driverName)
        print(driver.uid)
        nameLabel.text = driver.driverName
        destNameLabel.text = driver.destName
        let diff = driver.distDiff
        distDiffLabel.text = diff.description
        phoneField.text = driver?.phone
        let downloadImageRef = Storage.storage().reference().child("images").child("\(driver.uid).jpg")
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024*3) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
            print(error ?? "NO ERROR")
        }
        
        downloadtask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        downloadtask.resume()
        
        
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with: UIEvent?) {
        
        if motion == .motionShake{
            guard let number = URL(string: "tel://" + driver.phone) else { return }
            UIApplication.shared.open(number)
            
            
        }
        
    }
    
    @IBAction func textTapped(_ sender:UIButton){
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        if let user = user {
            ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let firstName = value?["first name"] as? String ?? ""
                let lastName = value?["last name"] as? String ?? ""
                let name = "\(firstName) \(lastName)"
                let sms: String = "sms:+1\(self.driver.phone)&body=Hey this is \(name), I found you over UVA Ride n Go, may I ask for a ride with you?)"
                let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

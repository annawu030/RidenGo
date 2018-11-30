//
//  VerifyEmailViewControlller.swift
//  final_project_mobile_wuwen
//
//  Created by Yunzhe Wu on 11/26/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class VerifyEmailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//    override func viewDidAppear(_ animated: Bool)  {
//        super.viewDidAppear(animated)
//        Auth.auth().currentUser?.reload()
//        print(Auth.auth().currentUser?.isEmailVerified)
//        if (Auth.auth().currentUser?.isEmailVerified)!{
//            self.performSegue(withIdentifier: "SignUpPagetoPersonalInfoSegue", sender: self)
//        }
//    }
    
    @IBAction func verifiedButtonTapped(sender:UIButton) {
        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil{
                if (Auth.auth().currentUser?.isEmailVerified)!{
                    self.performSegue(withIdentifier: "SignUpPagetoPersonalInfoSegue", sender: self)
                }
                else{
                    let alert = UIAlertController(title: "Verification Required", message: "Please verify your email and try again.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            } else {
                print("Not verified")
            }
        })
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "VerifyEmailSegue"){
//            guard let source = segue.source as? SignUpViewController,
//                let email = source.computingID,
//                let password = source.password else {return}
//
//            //  print(indexOfEdit)
//        }
//    }
    
}

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
        
        // Do any additional setup after loading the view.
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
            } else {
                print("Not verified")
            }
        })
    }

    
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

//
//  SignUpViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/14/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var UVAEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordReentryTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func signUpButtonTapped(_ sender:UIButton){
        if UVAEmailTextField.text != "" {
            if(passwordTextField.text == passwordReentryTextField.text){
                if let computingID = UVAEmailTextField.text, let pass = passwordTextField.text{
                    //Register the user with Firebase
                    print("hello what the heck is happeningnksdjnglkjnglkjfngkljdfng")
                        Auth.auth().createUser(withEmail: computingID + "@virginia.edu", password: pass, completion:  { (user,error) in
                        //Check that user isn't nil
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if let error = error
                            {print("Error when sending Email verification is \(error)")}
                        }
                        if let u = user{

                            //User is found, go to the next page you want the user to go to
                            self.performSegue(withIdentifier: "SignUpPagetoPersonalInfoSegue", sender: self)
                        }
                        else{
                            //Error:check error and show message
                        }
                    })
                }
            }
            else{
                //Error message that your passwords do not match
                print("hello what the heck is happening")
                let alert = UIAlertController(title: "Password Does Not Match", message: "Your passwords do not match! Please make sure they match and try again.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
        else{
            //Error message that your passwords do not match
            let alert = UIAlertController(title: "UVA Computing ID Required", message: "Please enter your UVA Computing ID and try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
}


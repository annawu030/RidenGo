//
//  ViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/12/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var loginIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Function for when user is trying to sign in
    @IBAction func signInButtonTapped(_ sender:UIButton){
        //Check some validation on email and passwords to make sure they are correct
        if let computingID = loginIDTextField.text, let pass = passwordTextField.text{
            Auth.auth().signIn(withEmail: computingID + "@virginia.edu", password: pass, completion: { (user, error) in
            //check that user is not nil
            //If user is real
                if let u = user{
                    // user is found, go to home screen
                    self.performSegue(withIdentifier: "PostSignInSegue", sender: self)
                }
                else{
                    //check error and show message
                }
            })
        }
            
    }
    @IBAction func signUpButtonTapped(_ sender:UIButton){
            self.performSegue(withIdentifier: "SignUpPageSegue", sender: self)
    
        
        }
        
    }



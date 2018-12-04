//
//  RODViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 12/4/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//
import UIKit

class RODViewController: UIViewController {
    @IBOutlet weak var RideButton: UIButton!
    @IBOutlet weak var DriveButton: UIButton!
    
    @IBAction func rideButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "Ride2MainSegue", sender: self)
    }
    
    @IBAction func driveButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "Drive2MainSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

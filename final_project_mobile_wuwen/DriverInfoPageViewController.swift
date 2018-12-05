//
//  DriverInfoPageViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/30/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit

class DriverInfoPageViewController: UIViewController {
    var driver: Driver!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var destNameLabel: UILabel!
    @IBOutlet weak var distDiffLabel: UILabel!
    @IBOutlet weak var phoneField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("INNNNNN DriverInfo")
        print(driver.driverName)
        print(driver.destName)
        nameLabel.text = driver.driverName
        destNameLabel.text = driver.destName
        let diff = driver.distDiff
        distDiffLabel.text = diff.description
        phoneField.text = driver?.phone

        // Do any additional setup after loading the view.
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

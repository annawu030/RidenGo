//
//  MainPageViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/14/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var radiusPicker: UIPickerView!
    
    var radiusPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Date & Time"
        radiusPickerData = ["3 miles", "5 miles", "7 miles", "10 miles", "15 miles", "20 miles"]
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

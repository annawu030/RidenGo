//
//  DriverListTableViewCell.swift
//  final_project_mobile_wuwen
//
//  Created by Yunzhe Wu on 12/4/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import Foundation
import UIKit

class DriverListTableViewCell: UITableViewCell {
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var destNameLabel: UILabel!
    @IBOutlet weak var distDiffLabel: UILabel!
//    @IBOutlet weak var profileImageView: UIImageView!
    
//    var driverName: String
//    var phone: String
//    var profile: String
//    var destName: String
//    var destLat: Double
//    var destLng: Double
//    var date: String
//    var distDiff: Double
    
    func update(with driver: Driver) {

        driverNameLabel.text = driver.driverName
        destNameLabel.text = driver.destName
        distDiffLabel.text = String(driver.distDiff)
//        profileImageView
    }
}

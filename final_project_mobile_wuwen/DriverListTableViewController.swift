//
//  DriverListViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Justine Wen on 11/30/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class DriverListTableViewController: UITableViewController{
    var refDrivers: DatabaseReference!
    var riderDate: String?
    var riderLat: Double?
    var riderLng: Double?
    var driverList = [Driver]()
//    var indexOfEdit: Int = 0
    @IBOutlet weak var tableViewDrivers: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        self.driverList = Driver.sortList(list: self.driverList)
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        if let user = user {
            ref.child("riders").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                self.riderDate = value?["date departure"] as? String ?? ""
                print(self.riderDate)
                let rLat = value?["dest lat"] as? String ?? ""
                let rLng = value?["dest lng"] as? String ?? ""
                self.riderLat = Double(rLat)
                self.riderLng = Double(rLng)
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
       // FirebaseApp.configure()
        refDrivers = Database.database().reference().child("drivers").child(self.riderDate!);
        refDrivers.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.driverList.removeAll()
                
                //iterating through all the values
                for drivers in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let driverObject = drivers.value as? [String: AnyObject]
                    let driverName  = driverObject?["name"]
                    let phone  = driverObject?["phone"]
                    let profile = driverObject?["profile"]
                    let destName = driverObject?["dest name"]
                    let destLat = driverObject?["dest lat"]
                    let destLng = driverObject?["dest lng"]
                    let date = driverObject?["date departure"]
                    
                    let coordinateRider = CLLocation(latitude: self.riderLat!, longitude: self.riderLng!)
                    let coordinateDriver = CLLocation(latitude: destLat as! CLLocationDegrees, longitude: destLng as! CLLocationDegrees)
                    let distDiff = coordinateDriver.distance(from: coordinateRider)
//                    let distDiff = driverObject?["dest lng"]
                    
                    
                    //creating artist object with model and fetched values
                    let driver = Driver(driverName: driverName as! String, phone: phone as! String, profile: profile as! String, destName: destName as! String, destLat: destLat as! Double, destLng: destLng as! Double, date: date as! String, distDiff: distDiff )
                    
                    //appending it to list
                    self.driverList.append(driver)
                }
                
                //reloading the tableview
                self.tableViewDrivers.reloadData()
            }
        })
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableViewDrivers.reloadData()
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdent = "DriverTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdent, for: indexPath) as! DriverTableViewCell
        
        let driver = driverList[indexPath.row]
        cell.driverNameLabel.text = driver.driverName
        cell.destNameLabel.text = driver.destName
        cell.distDiffLabel.text = String(driver.distDiff)
        return cell
    }
    
//    override func tableView(_ tableView: UITableView,
//                            editActionsForRowAt: IndexPath) -> [UITableViewRowAction]?{
//        let view = UITableViewRowAction(style: .normal, title: "View") { action, index in
//            //  item at indexPath
//            let cell = tableView.cellForRow(at: editActionsForRowAt)! as! DriverTableViewCell
//
//            let index = self.driverList.index(where: {$0.driverName == cell.driverNameLabel.text})
//            self.indexOfEdit = index!
//            self.performSegue(withIdentifier: "viewDriverInfo", sender: self.driverList[index!])
//            //  self.bucketItemList.remove(at: (indexPath.rsow-1))
//        }
//
//        view.backgroundColor = UIColor.blue
//        return [view]
//    }

}

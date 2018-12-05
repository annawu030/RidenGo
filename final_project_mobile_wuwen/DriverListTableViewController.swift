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
    var riderDate: String! = ""
    var riderLat: Double! = 0.0
    var riderLng: Double! = 0.0
    var driverList = [Driver]()
    var driverRecordList = [Driver]()
//    var indexOfEdit: Int = 0
    @IBOutlet weak var tableViewDrivers: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
//        self.driverList = Driver.sortList(list: self.driverList)
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
//        print("LOOOOOK ATTT MEEEE")
//        if let user = user {
//            print("I AM IN UUUUUUUUUSER")
//            print(user.uid)
//            ref.child("riders").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                // Get user value
//                let value = snapshot.value as? NSDictionary
//                let rDate = value?["date departure"] as? String ?? ""
//                print(rDate)
//                let rLat = value?["dest lat"] as? Double ?? 0.0
//                let rLng = value?["dest lng"] as? Double ?? 0.0
//                self.riderLat = rLat
//                self.riderLng = rLng
//                self.riderDate = rDate
////                print(self.riderDate!)
////                print(rLat)
////                print(rLng)
////                print(self.riderLng!)
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//            //            print(self.riderDate)
//        }
        print(self.riderLat)
        print(self.riderLng)
        print(self.riderDate)
        
        ref.child("drivers").child(self.riderDate).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount == 0{
                let alert = UIAlertController(title: "No Driver Available", message: "Seems like there are no available drivers for this date yet, try another day or check again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
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
                    let startName = driverObject?["start name"]
                    let startLat = driverObject?["start lat"]
                    let startLng = driverObject?["start lng"]
                    let destName = driverObject?["dest name"]
                    let destLat = driverObject?["dest lat"]
                    let destLng = driverObject?["dest lng"]
                    let date = driverObject?["date departure"]

                    let coordinateRider = CLLocation(latitude: self.riderLat!, longitude: self.riderLng!)
                    let coordinateDriver = CLLocation(latitude: destLat as! CLLocationDegrees, longitude: destLng as! CLLocationDegrees)
                    let distDiff = coordinateDriver.distance(from: coordinateRider)
                    //                    let distDiff = driverObject?["dest lng"]
                    let uid = drivers.key
//                    print("UUUUUUIIIIIIDDDDD")
//                    print(uid)


                    //creating artist object with model and fetched values
                    let driver = Driver(driverName: driverName as! String, phone: phone as! String, profile: profile as! String, startName: startName as! String, startLat: startLat as! Double, startLng: startLng as! Double, destName: destName as! String, destLat: destLat as! Double, destLng: destLng as! Double, date: date as! String, distDiff: distDiff, uid: uid)
//                    print(driver)

                    //appending it to list
                    self.driverList.append(driver)
//                    self.driverRecordList.append(driver)
                }

                //reloading the tableview
                self.tableView.reloadData()
            }
        })

       // FirebaseApp.configure()
//        print(driverList[0].driverName)
//        if (driverList.count == 0){
//            
//        }
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableViewDrivers.reloadData()
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110;//Choose your custom row height
    }
    
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
//        self.performSegue(withIdentifier: "viewDriverInfo", sender: driver)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt: IndexPath) -> [UITableViewRowAction]?{
        let view = UITableViewRowAction(style: .normal, title: "View") { action, index in
            //  item at indexPath
            let cell = tableView.cellForRow(at: editActionsForRowAt)! as! DriverTableViewCell

            let index = self.driverList.index(where: {$0.driverName == cell.driverNameLabel.text})
//            self.indexOfEdit = index!
            self.performSegue(withIdentifier: "viewDriverInfo", sender: self.driverList[index!])
            //  self.bucketItemList.remove(at: (indexPath.rsow-1))
        }

        view.backgroundColor = UIColor.blue
        return [view]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewDriverInfo"){
            let destination = segue.destination as! DriverInfoPageViewController
            let driverSender = sender as! Driver?
            destination.driver = driverSender
        }
    }

}

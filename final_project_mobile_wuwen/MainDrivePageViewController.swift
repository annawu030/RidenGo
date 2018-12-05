//
//  MainDrivePageViewController.swift
//  final_project_mobile_wuwen
//
//  Created by Yunzhe Wu on 12/4/18.
//  Copyright © 2018 final-wuwen. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase

class MainDrivePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //Radius Picker Portion
    @IBOutlet weak var pickerView: UIPickerView!
    let radius = ["3 miles", "5 miles", "7 miles", "10 miles", "15 miles", "20 miles"]
    
    @IBOutlet weak var dateField: UIDatePicker!
    
    var startPlaceLat: Double?
    var startPlaceLng: Double?
    @IBOutlet var startPlaceName: UITextField!
    
    var destLat: Double?
    var destLng: Double?
    @IBOutlet var destName: UITextField!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radius.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return radius[row]
    }
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        //Mapkit ViewDidLoad Section
        super.viewDidLoad()
        let lat = 38.8977
        let long = -77.0365
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        let initialLocation2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        let newPin = MKPointAnnotation()
        newPin.coordinate = initialLocation2D
        mapView.addAnnotation(newPin)

        let date = Date()
        let calendar = Calendar.current
        dateField.minimumDate = date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func startLocationTapped(_ sender:UIButton){
        self.performSegue(withIdentifier: "searchPlaceSegue", sender: self)
    }
    
    @IBAction func destinationTapped(_ sender:UIButton){
        self.performSegue(withIdentifier: "destinationSegue", sender: self)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if(segue.identifier == "searchPlaceToMainPageSeague"){
            print("HERE IN GEEEEET PLACE DETAIL!!!")
            let source = segue.source as? SearchPlaceViewController
            startPlaceName.text = source!.placeName
            startPlaceLat = source!.placeLat
            startPlaceLng = source!.placeLng
            
            let lat = startPlaceLat
            let long = startPlaceLng
            let initialLocation = CLLocation(latitude: lat!, longitude: long!)
            let initialLocation2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let regionRadius: CLLocationDistance = 1000
            func centerMapOnLocation(location: CLLocation) {
                let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                          latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
            }
            centerMapOnLocation(location: initialLocation)
            let newPin = MKPointAnnotation()
            newPin.coordinate = initialLocation2D
            mapView.addAnnotation(newPin)
            
        }
        if(segue.identifier == "searchDestToMainPageSeague"){
            print("HERE IN GEEEEET DEEEEST DETAIL!!!")
            let source = segue.source as? SearchDestViewController
//            print(source!.placeName)
//            print(source!.placeLat)
//            print(source!.placeLng)
            destName.text = source!.placeName
            destLat = source!.placeLat
            destLng = source!.placeLng
            
            let lat = destLat
            let long = destLng
            let destLocation = CLLocation(latitude: lat!, longitude: long!)
            let destLocation2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let regionRadius: CLLocationDistance = 1000
//            func centerMapOnLocation(location: CLLocation) {
//                let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
//                                                          latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//                mapView.setRegion(coordinateRegion, animated: true)
//            }
//            centerMapOnLocation(location: initialLocation)
            let destPin = MKPointAnnotation()
            destPin.coordinate = destLocation2D
            mapView.addAnnotation(destPin)
            
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("it is called")
        let date = dateField.date
//        print (date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy:MM:dd hh:mm:ss"
        let timeZone = TimeZone(identifier: "America/New_York")
        dateFormatter.timeZone = timeZone
        let strDate = dateFormatter.string(from: date)
        print (strDate)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyy:MM:dd"
        dateFormatter2.timeZone = timeZone
        let strDateID = dateFormatter2.string(from: date)
        print (strDateID)
//        let short = strDate.index(strDate.endIndex, offsetBy: -9)
//        print (strDate[short])
        
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        if let user = user {
            ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let firstName = value?["first name"] as? String ?? ""
                let lastName = value?["last name"] as? String ?? ""
                let name = "\(firstName) \(lastName)"
                let phone = value?["phone number"] as? String ?? ""
                let profile = value?["profile picture"] as? String ?? ""
                let userObject = [
                    "name": name,
                    "email": user.email!,
                    "phone": phone,
                    "profile": profile,
                    "start name": self.startPlaceName.text,
                    "start lat": self.startPlaceLat,
                    "start lng": self.startPlaceLng,
                    "dest name": self.destName.text,
                    "dest lat": self.destLat,
                    "dest lng": self.destLng,
                    "date departure": strDate,
                    ] as [String:Any]
                ref.child("drivers").child(strDateID).child(user.uid).setValue(userObject, withCompletionBlock: { error, ref in
                    if error == nil {
                        //                    self.performSegue(withIdentifier: "MainPageSegue", sender: self)
                        
                    } else {
                        // Handle the error
                        let alert = UIAlertController(title: "Repeat Date!", message: "You may only post 1 drive on chosen date. Please reschedule your drive.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                })
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }

//        performSegue(withIdentifier: , sender: self)
    }
}


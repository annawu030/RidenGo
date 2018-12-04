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

class MainDrivePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //Radius Picker Portion
    @IBOutlet weak var pickerView: UIPickerView!
    let radius = ["3 miles", "5 miles", "7 miles", "10 miles", "15 miles", "20 miles"]
    
//    @IBOutlet var startPlaceName: UITextField!
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
            let newPin = MKPointAnnotation()
            newPin.coordinate = destLocation2D
            mapView.addAnnotation(newPin)
            
        }
    }
    
}


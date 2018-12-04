//
//  PlaceAutoCompleteViewController.swift
//  GMS-MAPVIEW
//
//  Created by MAC-4 on 10/26/17.
//  Copyright © 2017 Prismetric-MD2. All rights reserved.
//

import UIKit
import GooglePlaces

enum viewIdentifier {
    case menu
    case souceLocation
    case destinationLocation
}

protocol SelectedLocationDelegate {
    func didSelectedLocation(identifier:viewIdentifier, selectedPlace:Place)
}

class SearchPlaceViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var txtSearch: UITextField!
    var selectedPlace: Place = Place()
    var placeName: String?
    var placeLat: Double?
    var placeLng: Double?
    
    
    lazy var filter:GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        return filter
    }()
    
    var googlePlace = [GMSAutocompletePrediction]()
    
    var delegate:SelectedLocationDelegate!
    
    var comeFrom:viewIdentifier = viewIdentifier.menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func back_clicked(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googlePlace.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.attributedText = googlePlace[indexPath.row].attributedPrimaryText
        cell?.textLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        
        cell?.detailTextLabel?.attributedText = googlePlace[indexPath.row].attributedSecondaryText
        cell?.detailTextLabel?.font = UIFont(name: "Avenir-Medium", size: 12)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if comeFrom != .menu {
        GMSPlacesClient.shared().lookUpPlaceID(googlePlace[indexPath.row].placeID ?? "") { (place, error) in
            if error == nil && place != nil {
//                print(place!.formattedAddress!)
//                let selectedPlace = Place()
                self.selectedPlace.address = place!.formattedAddress!
                self.selectedPlace.name = place!.name
                self.selectedPlace.id = place!.placeID
                //get latitude and longitude
                self.selectedPlace.lat = place?.coordinate.latitude ?? 0.0
                self.selectedPlace.lng = place?.coordinate.longitude ?? 0.0
                self.delegate?.didSelectedLocation(identifier: self.comeFrom, selectedPlace: self.selectedPlace)
//                self.navigationController?.popViewController (animated: true)
                print("IIIIIII AMMMM HHHERE")
                print(self.selectedPlace.name)
                self.placeName = self.selectedPlace.name
                self.placeLat = self.selectedPlace.lat
                self.placeLng = self.selectedPlace.lng
                print(self.placeName)
                print(self.placeLat)
                print(self.placeLng)
                self.txtSearch.text = self.placeName
//                self.performSegue(withIdentifier: "searchPlaceToMainPageSeague", sender: self)
            }
            else {
                debugPrint("Someting went wrong please try again.")
            }
//            }
        }
        
    }
//    @IBAction func signUpButtonTapped(_ sender:UIButton){
//        self.performSegue(withIdentifier: "searchPlaceToMainPageSeague", sender: self)
//    }
}

extension SearchPlaceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("HEEEEEEEEY")
        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        print(searchString)
    
        GMSPlacesClient.shared().autocompleteQuery(searchString, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            
            if let results = results {
//                print("I AMMMMMM HEEEEEERE")
                self.googlePlace = results
                self.tableView.reloadData()
            }
        })
        return true
    }
}

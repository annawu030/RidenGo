//
//  BucketItem.swift
//  WuWen iOS Mini App
//
//  Created by Justine Wen on 9/30/18.
//  Copyright © 2018 WuWen. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Driver {
    
    var driverName: String
    var phone: String
    var profile: String
    var destName: String
    var destLat: Double
    var destLng: Double
    var date: String
    var distDiff: Double
    
    init(driverName: String, phone: String, profile: String, destName: String, destLat: Double, destLng: Double, date: String, distDiff: Double) {
        self.driverName = driverName
        self.phone = phone
        self.profile = profile
        self.destName = destName
        self.destLat = destLat
        self.destLng = destLng
        self.date = date
        self.distDiff = distDiff
    }
    
    static func sortList(list: Array<Driver>) -> Array<Driver> {
//        let user = Auth.auth().currentUser
//        let ref = Database.database().reference()
//        if let user = user {
//            ref.child("riders").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                // Get user value
//                let value = snapshot.value as? NSDictionary
//                let rLat = value?["dest lat"] as? String ?? ""
//                let rLng = value?["dest lng"] as? String ?? ""
//                let riderLat = Double(rLat)
//                let riderLng = Double(rLng)
//
//                let coordinateRider = CLLocation(latitude: riderLat!, longitude: riderLng!)
//                let coordinateDriver = CLLocation(latitude: 5.0, longitude: 3.0)
//
//                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//
//        }
        return list.sorted{ driver1, driver2 in
//            let coordinateDriver1 = CLLocation(latitude: driver1.destLat, longitude: driver1.destLng)
//            let coordinateDriver2 = CLLocation(latitude: driver2.destLat, longitude: driver2.destLng)
//            let distRD1 = coordinateRider.distance(from: coordinateDriver1)
//            let distRD2 = coordinateRider.distance(from: coordinateDriver2)
//            if distRD1 < distRD2{
            return driver1.distDiff < driver2.distDiff
//            }
//            return !bucketItem1.check && bucketItem2.check
        }
    }
}

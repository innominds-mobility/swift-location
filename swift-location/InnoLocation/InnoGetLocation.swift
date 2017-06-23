//
//  InnoGetLocation.swift
//  swift-location
//
//  Created by Harika Annam on 6/15/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import CoreLocation

/// The purpose of this class is to get the location.
/// The `InnoGetLocation` class is a subclass of the `NSObject`.
public final class InnoGetLocation: NSObject, CLLocationManagerDelegate {
    /// CLLocationManager object for getting the location
    var locationManager: CLLocationManager!

    /// This method declares location delegate,location options and starts the update the location.
    public func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location service disabled")
        }
    }
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    ///This method will be called each time when a user change his location access preference.
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    //
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /// User location details
        let userLocation: CLLocation = locations[0] as CLLocation
        /// It holds latitude,longitude values
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                   longitude: userLocation.coordinate.longitude)
        /// Get the location details
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinations.latitude, longitude: coordinations.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                /// Place details
                var placeMark: CLPlacemark?
                placeMark = placemarks?[0]
//                let latDic = [
//                    "Latitude : \(coordinations.latitude)",
//                    "Longitude : \(coordinations.longitude)"
//                ]
                if placeMark?.addressDictionary != nil {
                    NotificationCenter.default.post(name:
                        Notification.Name(rawValue: "LocationIdentifier"),
                                                    object:userLocation, userInfo:placeMark?.addressDictionary)
                }
            } else {
                print("error :: \(String(describing: error))")
            }
        })
       // manager.stopUpdatingLocation()
    }
}

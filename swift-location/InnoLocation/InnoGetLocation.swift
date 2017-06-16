//
//  InnoGetLocation.swift
//  swift-location
//
//  Created by Harika Annam on 6/15/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import CoreLocation

public final class InnoGetLocation: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

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
    //this method will be called each time when a user change his location access preference.
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
        let userLocation: CLLocation = locations[0] as CLLocation
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                   longitude: userLocation.coordinate.longitude)
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinations.latitude, longitude: coordinations.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            let latDic = [
                "Latitude : \(coordinations.latitude)",
                "Longitude : \(coordinations.longitude)"
            ]

            if placeMark?.addressDictionary != nil {
                NotificationCenter.default.post(name:
                    Notification.Name(rawValue: "NotificationIdentifier"),
                                                object:latDic, userInfo:placeMark?.addressDictionary)
            }
        })
        //manager.stopUpdatingLocation()
    }
}

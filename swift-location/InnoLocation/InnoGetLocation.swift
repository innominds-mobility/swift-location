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
    var oldLocation = CLLocation()
    var geocoder = CLGeocoder()
    /// This method declares location delegate,location options and starts the update the location.
    public func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location service disabled")
        }
    }
//    func isAuthorizedtoGetUserLocation() {
//        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
    /// Setting distanceFilter value to locationmanager
    ///
    ///
    public func setDistanceFilter(_ value: Double) {
        if self.locationManager != nil {
            locationManager.distanceFilter = CLLocationDistance(value)
        }
    }
    /// Setting location should run
    /// background or not to value to locationmanager
    ///
    public func enabledLocationInBackground(_ isEnable: Bool) {
        if self.locationManager != nil {
            if isEnable {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    /// Setting desiredAccuracy value to locationmanager
    ///
    ///
    public func accuracyChanged(_ index: Int) {
        let accuracyValues = [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers]
        if self.locationManager != nil {
            locationManager.desiredAccuracy = accuracyValues[index]
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
        let distance = Double(userLocation.distance(from: oldLocation))
        oldLocation = userLocation
        print("distance  \(distance)")
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
    /// Forward Geocoding
    /// from address finds the
    /// location latitude and longitude values
    public func forwardGeocoding(address: String, completion: @escaping (_ value: String) -> Void) {
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            if error == nil {
                var location: CLLocation?
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                if let location = location {
                    let coordinate = location.coordinate
                    completion("\(coordinate.latitude), \(coordinate.longitude)")
                } else {
                    completion("No Matching Location Found")
                }
            } else {
                completion("Unable to Find Location for Address")
            }
        }

    }
    /// Reverse Geocoding
    /// from latitude and longitude values finds the
    /// location full details
    public func reverseGeocoding(lat: Double, long: Double, completion: @escaping (_ value: String) -> Void) {
        let location = CLLocation(latitude: lat, longitude: long)
        // Geocode Location
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                /// Place details
                var placeMark: CLPlacemark?
                placeMark = placemarks?[0]
                if placeMark?.addressDictionary != nil {
                    let placeMark = placeMark?.addressDictionary as NSDictionary?
                    /// Location name
                    var result = String()

                    if let locationName = placeMark?["Name"] as? NSString {
                        result += "\(locationName)"
                    }
//                    /// Street address
//                    if let street = placeMark!["Thoroughfare"] as? NSString {
//                        result += ",\(street)"
//                    }
                    /// City name
                    if let city = placeMark!["City"] as? NSString {
                        result += ",\(city)"
                    }
                    /// State name
                    if let state = placeMark!["State"] as? NSString {
                        result += ",\(state)"
                    }
                    /// Country name
                    if let country = placeMark!["Country"] as? NSString {
                        result += ",\(country)"
                    }
                    /// Zip code
                    if let zip = placeMark!["ZIP"] as? NSString {
                        result += ",\(zip)"
                    }
                    completion(result)

                } else {
                    completion("No Matching Addresses Found")
                }
            } else {
                completion("Unable to Find Location for Address")
            }
        })
    }

}

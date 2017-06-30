//
//  GoogleLocationViewController.swift
//  swift-location
//
//  Created by Harika Annam on 6/23/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class GoogleLocationViewController: UIViewController {
    var userLocation = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Google Map"
        let coordinations = CLLocationCoordinate2D(latitude: (self.userLocation.coordinate.latitude),
                                                   longitude: (self.userLocation.coordinate.longitude))
        let camera = GMSCameraPosition.camera(withLatitude: coordinations.latitude,
                                              longitude:coordinations.longitude, zoom: 10)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        //mapView.delegate = self
        self.view = mapView
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coordinations.latitude, coordinations.longitude)
        marker.map = mapView
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(
        CLLocationCoordinate2DMake(coordinations.latitude, coordinations.longitude)) { response, error in
            if error == nil {
                if let address = response?.firstResult() {
                    print("Address from google  \(address)")
                    marker.title = address.locality
                    marker.snippet = address.administrativeArea
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

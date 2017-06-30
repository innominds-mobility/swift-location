//
//  AppleLocationViewController.swift
//  swift-location
//
//  Created by Harika Annam on 6/30/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import MapKit

class AppleLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let annotationPin = MKPointAnnotation()

    var userLocation = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple Map"
        let coordinations = CLLocationCoordinate2D(latitude: (self.userLocation.coordinate.latitude),
                                                   longitude: (self.userLocation.coordinate.longitude))
        let region = MKCoordinateRegion(center: coordinations, span:
            MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        annotationPin.coordinate = userLocation.coordinate
        self.mapView.addAnnotation(annotationPin)

        // Do any additional setup after loading the view.
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

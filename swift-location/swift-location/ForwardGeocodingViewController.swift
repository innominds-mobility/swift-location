//
//  ForwardGeocodingViewController.swift
//  swift-location
//
//  Created by Harika Annam on 7/3/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import InnoLocation
/// The purpose of this view controller is to provide a user interface for displaying user location.
/// There's a matching scene in the *Main.storyboard* file,
/// and in that scene there is textfields,button and label for showing location details.
/// Go to Interface Builder for details.
/// The `ReverseGeoCodingViewController` class is a subclass of the `UIViewController`.
class ForwardGeocodingViewController: UIViewController {
    /// Object for InnoGetLocation class
    var locationObj = InnoGetLocation()
    // textfield for country name
    @IBOutlet var countryTextField: UITextField!
    // textfield for street name
    @IBOutlet var streetTextField: UITextField!
    // textfield for city name
    @IBOutlet var cityTextField: UITextField!
    // button for perform action to get values
    @IBOutlet var geocodeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    // label for displaying latitude and longitude values
    @IBOutlet var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Forward Geocoding"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// Pass the address to forward gecoding
    /// and returns the result coordinates value
    /// displays the value in label
    @IBAction func geoCodingBtnAction(_ sender: Any) {
        guard let countryName = countryTextField.text else { return }
        guard let streetName = streetTextField.text else { return }
        guard let cityName = cityTextField.text else { return }
        // Create Address String
        let addressLocation = "\(countryName), \(streetName), \(cityName)"
        geocodeButton.isHidden = true
        activityIndicatorView.startAnimating()
        locationObj.forwardGeocoding(address: addressLocation) { (locationValue) in
            self.geocodeButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            self.locationLabel.text = locationValue
        }
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

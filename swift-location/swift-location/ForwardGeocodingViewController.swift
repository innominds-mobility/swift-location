//
//  ForwardGeocodingViewController.swift
//  swift-location
//
//  Created by Harika Annam on 7/3/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import InnoLocation

class ForwardGeocodingViewController: UIViewController {
    /// Object for InnoGetLocation class
    var locationObj = InnoGetLocation()
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var geocodeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
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
    @IBAction func geoCodingBtnAction(_ sender: Any) {
        guard let country = countryTextField.text else { return }
        guard let street = streetTextField.text else { return }
        guard let city = cityTextField.text else { return }
        // Create Address String
        let addressLocation = "\(country), \(city), \(street)"
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

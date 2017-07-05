//
//  ReverseGeoCodingViewController.swift
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
class ReverseGeoCodingViewController: UIViewController {
    /// Object for InnoGetLocation class
    var locationObj = InnoGetLocation()
    // textfield for longitude value
    @IBOutlet weak var longitudeTextfield: UITextField!
    // textfield for latitude name
    @IBOutlet weak var latitudeTextField: UITextField!
    // button for perform action to get values
    @IBOutlet var reverseGeocodeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    // label for displaying address value
    @IBOutlet var locationLabel: UILabel!
    /// Object for InnoLocationIq class
    var locationIqObj = InnoLocationIq()
    // button for perform action to get locationIq values
    @IBOutlet weak var locationIqButton: UIButton!
    @IBOutlet weak var locationIqActivityIndicatorView: UIActivityIndicatorView!
    // label for displaying locationIq address value
    @IBOutlet weak var locationIqLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Reverse Geocoding"

    }
    /// Pass the coordinates to reverse gecoding
    /// and returns the result address value
    /// displays the value in label
    @IBAction func reverseGeocodeBtnAction(_ sender: Any) {
        self.locationLabel.text = ""
        guard let latitudeValue = latitudeTextField.text, let latitude = Double(latitudeValue) else { return }
        guard let longitudeValue = longitudeTextfield.text, let longitude = Double(longitudeValue) else { return }
        reverseGeocodeButton.isHidden = true
        activityIndicatorView.startAnimating()
        locationObj.reverseGeocoding(lat: latitude, long: longitude) { (resultAddress) in
            self.reverseGeocodeButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            self.locationLabel.text = resultAddress
        }
    }
    /// Pass the coordinates to locationIq reverse gecoding
    /// and returns the result address value
    /// displays the value in label
    @IBAction func locationIqBtnAction(_ sender: Any) {
        self.locationIqLabel.text = ""
        guard let latitudeValue = latitudeTextField.text, let latitude = Double(latitudeValue) else { return }
        guard let longitudeValue = longitudeTextfield.text, let longitude = Double(longitudeValue) else { return }
        locationIqButton.isHidden = true
        locationIqActivityIndicatorView.startAnimating()
        locationIqObj.locationIqReverseGeocoding(lat: latitude, long: longitude) { (resultValue, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.locationIqButton.isHidden = false
                    self.locationIqActivityIndicatorView.stopAnimating()
                    self.locationIqLabel.text = (resultValue as AnyObject).value(forKey: "display_name") as? String
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

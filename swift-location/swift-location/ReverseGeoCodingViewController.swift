//
//  ReverseGeoCodingViewController.swift
//  swift-location
//
//  Created by Harika Annam on 7/3/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import InnoLocation

class ReverseGeoCodingViewController: UIViewController {
    /// Object for InnoGetLocation class
    var locationObj = InnoGetLocation()
    @IBOutlet weak var longitudeTextfield: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet var reverseGeocodeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Reverse Geocoding"

    }

    @IBAction func reverseGeocodeBtnAction(_ sender: Any) {
        guard let latitudeValue = latitudeTextField.text, let latitude = Double(latitudeValue) else { return }
        guard let longitudeValue = longitudeTextfield.text, let longitude = Double(longitudeValue) else { return }
        self.locationLabel.text = ""
        reverseGeocodeButton.isHidden = true
        activityIndicatorView.startAnimating()
        locationObj.reverseGeocoding(lat: latitude, long: longitude) { (resultAddress) in
            self.reverseGeocodeButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            self.locationLabel.text = resultAddress
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

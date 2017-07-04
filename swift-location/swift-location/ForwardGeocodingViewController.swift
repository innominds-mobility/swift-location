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
class ForwardGeocodingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var locationTableView: UITableView!
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
    var locationIqObj = InnoLocationIq()
    let locationDetails = NSMutableArray()
    let cellReUseIdentifier = "cell"
    @IBOutlet weak var locationIqGeocodeBtn: UIButton!
    @IBOutlet weak var locationIqActivityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Forward Geocoding"
        locationTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReUseIdentifier)

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
        let addressLocation = "\(countryName),\(streetName),\(cityName)"
        geocodeButton.isHidden = true
        activityIndicatorView.startAnimating()
        locationObj.forwardGeocoding(address: addressLocation) { (locationValue) in
            self.geocodeButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            self.locationLabel.text = locationValue
        }
    }
    @IBAction func locationIqGeocodeBtnAction(_ sender: Any) {
        guard let countryName = countryTextField.text else { return }
        guard let streetName = streetTextField.text else { return }
        guard let cityName = cityTextField.text else { return }
        // Create Address String
        let addressLocation = "\(streetName),\(cityName),\(countryName)"
        locationIqGeocodeBtn.isHidden = true
        locationIqActivityIndicatorView.startAnimating()
        locationIqObj.locationIqForwardGeocoding(address: addressLocation) { (resultValue, error) in
            if error == nil {
                self.locationDetails.removeAllObjects()
                self.locationDetails.addObjects(from: resultValue!)
                DispatchQueue.main.async {
                    self.locationIqGeocodeBtn.isHidden = false
                    self.locationIqActivityIndicatorView.stopAnimating()
                    self.locationTableView.reloadData()

                }
            }
        }
    }
    // MARK: - Tableview data source methods
    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameters:
    ///   - tableView: An object representing the table view requesting this information.
    ///   - section: section in tableview
    /// - Returns: The number of sections in tableView. The default value is 1.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDetails.count
    }
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that
    /// the table view can use for the specified row. An assertion is raised if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// create a new cell if needed or reuse an old one
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: cellReUseIdentifier) as UITableViewCell!
        let latitude = ((self.locationDetails.object(at: indexPath.row) as AnyObject).value(forKey: "lat")  as? String)
        let longitude = ((self.locationDetails.object(at: indexPath.row) as AnyObject).value(forKey: "lon")  as? String)
        cell.textLabel?.text = "\(latitude ?? "nil"), \(longitude ?? "nil")"
        return cell
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

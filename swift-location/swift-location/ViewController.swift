//
//  ViewController.swift
//  swift-location
//
//  Created by Harika Annam on 5/22/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import InnoLocation
import CoreLocation
/// The purpose of this view controller is to provide a user interface for displaying user location.
/// There's a matching scene in the *Main.storyboard* file, 
/// and in that scene there is tableview for showing location details.
/// Go to Interface Builder for details.
/// The `ViewController` class is a subclass of the `UIViewController`.
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var userCoordinates = CLLocation()
    // MARK: - IBOutlet Properties
    @IBOutlet weak var filterValueTF: UITextField!
    /// The tableview for the location details.
    @IBOutlet weak var locationTabelView: UITableView!
    /// Object for InnoGetLocation class
    var locationObj = InnoGetLocation()
    /// cell reuse id (cells that scroll out of view can be reused)
    let cellReUseIdentifier = "cell"
    /// Data model: location values will be the data for the table view cells
    let locationDetails = NSMutableArray()

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(
                                                ViewController.receivingLocationNotification(notification:)),
                                               name: Notification.Name("LocationIdentifier"),
                                               object: nil)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationTabelView.register(UITableViewCell.self, forCellReuseIdentifier: cellReUseIdentifier)
       // _ = Timer.scheduledTimer(timeInterval: 10, target: self,
                                // selector: #selector(self.callLocation), userInfo: nil, repeats: true)
        locationObj.getLocation()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false

    }
    /// Notification handler for receiving location
    ///
    /// - Parameter notification: notification object
    func receivingLocationNotification(notification: Notification) {
        //Take Action on Notification
        self.locationDetails.removeAllObjects()
        /// coordinates object latitude,longitude
        self.userCoordinates = (notification.object as? CLLocation)!

//        self.locationDetails.add(coordinates?.object(at: 0) ?? "nil")
//        self.locationDetails.add(coordinates?.object(at: 1) ?? "nil")
        self.locationDetails.add("Latitude  :\(String(describing: userCoordinates.coordinate.latitude))")
        self.locationDetails.add("Longitude  :\(String(describing: userCoordinates.coordinate.longitude))")
        let placeMark = notification.userInfo as NSDictionary?
        /// Location name
        if let locationName = placeMark?["Name"] as? NSString {
            self.locationDetails.add("LocationName : \(locationName)")
        }
        /// Street address
        if let street = placeMark!["Thoroughfare"] as? NSString {
            self.locationDetails.add("Street : \(street)")

        }
        /// City name
        if let city = placeMark!["City"] as? NSString {
            self.locationDetails.add("City : \(city)")
        }
        /// State name
        if let state = placeMark!["State"] as? NSString {
            self.locationDetails.add("State : \(state)")
        }
        /// Country name
        if let country = placeMark!["Country"] as? NSString {
            self.locationDetails.add("Country : \(country)")
        }
        /// Zip code
        if let zip = placeMark!["ZIP"] as? NSString {
            self.locationDetails.add("Zip : \(zip)")

        }
        self.locationTabelView.reloadData()

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
        cell.textLabel?.text = self.locationDetails[indexPath.row] as? String
        return cell
    }
    // MARK: - TextField delegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn
                   range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// Passing the user location
    /// to GoogleLocationViewController
    ///
    @IBAction func googleLocationBtnAction(_ sender: Any) {
        if let googleLocationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            "GoogleLocationViewController") as? GoogleLocationViewController {
            if let navigator = navigationController {
                googleLocationVC.userLocation = self.userCoordinates
                navigator.pushViewController(googleLocationVC, animated: true)
            }
        }
    }
    /// Passing the user location
    /// to AppleLocationViewController
    ///
    @IBAction func appleLocationBtnAction(_ sender: Any) {
        if let appleLocationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            "AppleLocationViewController") as? AppleLocationViewController {
            if let navigator = navigationController {
                appleLocationVC.userLocation = self.userCoordinates
                navigator.pushViewController(appleLocationVC, animated: true)
            }
        }
    }
    /// Selected value is sending
    /// to enable or disable
    /// background location service
    @IBAction func enabledValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            locationObj.enabledLocationInBackground(true)
        } else {
            locationObj.enabledLocationInBackground(false)

        }
    }
    /// Selected segmentcontrol value is sending
    /// based on accuracy value location work
    ///
    @IBAction func accuracyChanged(_ sender: UISegmentedControl) {
        locationObj.accuracyChanged(sender.selectedSegmentIndex)
    }
    /// Sending the distance filter value
    ///
    ///
    @IBAction func distanceFilterBtnAction(_ sender: Any) {
        if !(self.filterValueTF.text?.isEmpty)! {
            locationObj.setDistanceFilter(Double(self.filterValueTF.text!)!)

        }
    }
    /// Pushing to ReverseGeoCodingViewController
    ///
    ///
    @IBAction func reverseGeocodingBtnAction(_ sender: Any) {
        if let reverseGeocodingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            "ReverseGeoCodingViewController") as? ReverseGeoCodingViewController {
            if let navigator = navigationController {
                navigator.pushViewController(reverseGeocodingVC, animated: true)
            }
        }
    }
    /// Pushing to ForwardGeocodingViewController
    ///
    ///
    @IBAction func fwdGeocodingBtnAction(_ sender: Any) {
        if let forwardGeocodingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            "ForwardGeocodingViewController") as? ForwardGeocodingViewController {
            if let navigator = navigationController {
                navigator.pushViewController(forwardGeocodingVC, animated: true)
            }
        }
    }
}

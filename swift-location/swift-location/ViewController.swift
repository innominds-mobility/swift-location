//
//  ViewController.swift
//  swift-location
//
//  Created by Harika Annam on 5/22/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit
import InnoLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   //
    @IBOutlet weak var locationTabelView: UITableView!
    var locationObj = InnoGetLocation()

    let cellReUseIdentifier = "cell"
    let locationDetails = NSMutableArray()

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(
                                                ViewController.methodOfReceivedNotification(notification:)),
                                               name: Notification.Name("NotificationIdentifier"),
                                               object: nil)

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationTabelView.register(UITableViewCell.self, forCellReuseIdentifier: cellReUseIdentifier)
        locationObj.getLocation()
       // self.initLocationManager()
    }
    func methodOfReceivedNotification(notification: Notification) {
        //Take Action on Notification
        self.locationDetails.removeAllObjects()
        let coordinates = notification.object as? NSArray

        self.locationDetails.add(coordinates?.object(at: 0) ?? "nil")
        self.locationDetails.add(coordinates?.object(at: 1) ?? "nil")
        let placeMark = notification.userInfo as NSDictionary?
        if let locationName = placeMark?["Name"] as? NSString {
            self.locationDetails.add("LocationName : \(locationName)")
        }
        // Street address
        if let street = placeMark!["Thoroughfare"] as? NSString {
            self.locationDetails.add("Street : \(street)")

        }
        // City
        if let city = placeMark!["City"] as? NSString {
            self.locationDetails.add("City : \(city)")
        }
        // State address
        if let state = placeMark!["State"] as? NSString {
            self.locationDetails.add("State : \(state)")
        }
        // Country
        if let country = placeMark!["Country"] as? NSString {
            self.locationDetails.add("Country : \(country)")
        }
        // Zip code
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

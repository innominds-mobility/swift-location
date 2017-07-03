# swift-location
Location wrapper to handle different location based call systems

To integrate Location generic framework into your Xcode project manually
add `InnoLocation` module to your project.

```swift
import InnoLocation
```
### Get user location
#### Description
With `InnoGetLocation`, you can get the user's location based on latitude and longitude. By using reverseGeocoding you can get the below information from placemark
* LocationName
* Thoroughfare
* Country
* State
* City
* ZIP
![InnoGetLocation Icon](Resources/InnoGetLocation.png "InnoGetLocation Icon")
#### Usage
Create an `InnoGetLocation` object .
```swift
var locationObj = InnoGetLocation()
```
Add observer to get updated user location and call `getLocation()` method.
```swift
//In ViewDidLoad
NotificationCenter.default.addObserver(self,  selector: #selector(ViewController.receivingLocationNotification(notification:)),
name: Notification.Name("LocationIdentifier"),object: nil)
locationObj.getLocation()
```
For receiving location information below notification handler method is used. In `notification object` contains latitude,longitude values and `userInfo object` contains placemark details.
```swift
func receivingLocationNotification(notification: Notification)
```
### Filter user location based on accuracy
#### Description
Based on the selected accuracy will get the user location.
#### Usage
Pass the accuracy value to ` public func accuracyChanged(_ index: Int)` menthod in `InnoLocation` class
```swift
locationObj.accuracyChanged(sender.selectedSegmentIndex)
```
### Support in background modes
#### Description
User location will get updated when application in background mode.
#### Usage
To enable location services in background into your project. Go to targets in `capabilities` enable `Background Modes` and select `Location updates`.
Pass the location should enable in background value to `public func enabledLocationInBackground(_ isEnable: Bool)` menthod in `InnoLocation` class
```swift
func enabledValueChanged(_ sender: UISwitch) {
if sender.isOn {
locationObj.enabledLocationInBackground(true)
} else {
locationObj.enabledLocationInBackground(false)
}
}
```
![InnoGetLocation Icon](Resources/InnoHome.png "InnoHome Icon")
### User moves a certain distance (granular based)
#### Description
Based on the `distanceFilter` value location will get updated.
#### Usage
To set the distanceFilter value pass the required value to `public func setDistanceFilter(_ value: Double)` menthod in `InnoLocation` class
```swift
locationObj.setDistanceFilter(Double(self.filterValueTF.text!)!)
```
### Support for GoogleMaps
#### Description
It shows the user location in google map.
#### Installation
To integrate Google Maps SDK for iOS into your Xcode project using CocoaPods, specify it in your Podfile:
```swift
platform :ios, '9.0'
target 'YOUR_APPLICATION_TARGET_NAME_HERE' do
pod 'GoogleMaps
pod 'GooglePlaces'
end
```
Then, run the following command:
```swift
$ pod install
```
### To create google API key follow the below steps:
1. Go to the `Google API Console`.
2. Create or select a project.
3. Click Continue to enable the Google Maps SDK for iOS.
4. On the Credentials page, get an API key. 
Note: If you have a key with iOS restrictions, you may use that key. You can use the same key with any of your iOS applications within the same project.
5. From the dialog displaying the API key, select Restrict key to set an iOS restriction on the API key.
6. In the Restrictions section, select iOS apps, then enter your app's bundle identifier. For example: com.example.appname.
7. Click Save.
Your new iOS-restricted API key appears in the list of API keys for your project. An API key is a string of characters, something like this:
`AIzaSyDClEP-gsuT5jz4kFgnQ8g4F85_RtLZK9U`
#### Usage
To use google maps framewok in application. In `Appdelegate.swift`class import the framework
```swift
import GoogleMaps
import GooglePlaces
```
In didFinishLaunchingWithOptions method set the API key as below
```swift
GMSServices.provideAPIKey("AIzaSyDClEP-gsuT5jz4kFgnQ8g4F85_RtLZK9U")
GMSPlacesClient.provideAPIKey("AIzaSyDClEP-gsuT5jz4kFgnQ8g4F85_RtLZK9U")
```
Pass the user loaction to `GoogleLocationViewController` class to display the location in google map.
```swift
import CoreLocation
import GoogleMaps
import GooglePlaces
```
In `viewDidLoad()` declare the GMSCameraPosition,GMSMapView and GMSMarker
```swift
let coordinations = CLLocationCoordinate2D
(latitude:(userLocation.coordinate.latitude), 
longitude: (userLocation.coordinate.longitude))
let camera = GMSCameraPosition.camera(withLatitude: coordinations.latitude,longitude:coordinations.longitude, zoom: 10)
let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
mapView.isMyLocationEnabled = true
self.view = mapView
let marker = GMSMarker()
marker.position = CLLocationCoordinate2DMake(coordinations.latitude, coordinations.longitude)
marker.map = mapView
```
By using the reverse geociding displaying the location in google map.
```swift
let geocoder = GMSGeocoder()
geocoder.reverseGeocodeCoordinate(
CLLocationCoordinate2DMake(coordinations.latitude, coordinations.longitude)) 
{ response, error in
if error == nil {
if let address = response?.firstResult() {
print("Address from google  \(address)")
marker.title = address.locality
marker.snippet = address.administrativeArea
}
}
}
```
![InnoGetLocation Icon](Resources/InnoGoogleLocation.png "InnoGoogleLocation Icon")
### Support for AppleMaps
#### Description
It shows the user location in apple map. By using the `MapKit` framework will display the location in map.
#### Usage
Import `Mapkit` framework. Create `MKMapView` object and connect to stroryboard. Declare `MKPointAnnotation` object.
object to show the pinAnnotation for location.
```swift
import MapKit
@IBOutlet weak var mapView: MKMapView!
let annotationPin = MKPointAnnotation()
var userLocation = CLLocation()
```
Pass the user location to `AppleLocationViewController` class to display the location in apple map. In `viewDidLoad()` based on `MKCoordinateRegion` displaying location.
```swift
let coordinations = CLLocationCoordinate2D(latitude: (userLocation.coordinate.latitude),
longitude: (userLocation.coordinate.longitude))
let region = MKCoordinateRegion(center: coordinations, span:
MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
self.mapView.setRegion(region, animated: true)
annotationPin.coordinate = userLocation.coordinate
self.mapView.addAnnotation(annotationPin)
```
![InnoGetLocation Icon](Resources/InnoAppleLocation.png "InnoAppleLocation Icon")

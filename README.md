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

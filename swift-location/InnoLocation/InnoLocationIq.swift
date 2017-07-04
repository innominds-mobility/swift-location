//
//  InnoLocationIq.swift
//  swift-location
//
//  Created by Harika Annam on 7/4/17.
//  Copyright © 2017 Innominds Mobility. All rights reserved.
//

import UIKit

public final class InnoLocationIq: NSObject {
    public func locationIqReverseGeocoding(lat: Double,
                                           long: Double,
                                           completion: @escaping (_ value: [String: Any]?,
                                           _ errorStr: Error?) -> Void) {
        let urlStr = "http://locationiq.org/v1/reverse.php?format=json&key=8aeb1851e34b30897833&lat=\(lat)&lon=\(long)&zoom=18&addressdetails=1"
        guard let url = NSURL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url:url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                completion(json, error)
            } catch {
                completion(nil, error)
            }
        })
        task.resume()
    }
    public func locationIqForwardGeocoding(address: String,
                                           completion: @escaping (_ value: Array<Any>?, _ errorStr: Error?) -> Void) {
        let urlStr = "http://locationiq.org/v1/search.php?key=8aeb1851e34b30897833&format=json&q=\(address)"
        guard let url = NSURL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url:url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Array<Any>
                completion(json, error)
            } catch {
                completion([], error)
            }
        })
        task.resume()
    }
}

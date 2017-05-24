//
//  APIGoogle.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import Alamofire

class APIGoogle: NSObject {

    private var apiKey: String = ""
    
    override init() {
        super.init()
        apiKey = self.valueForAPIKey(named: "API_GOOGLE")
    }
    
    private func valueForAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "Key", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
    
    public func getPlaceAutocomplete(address: String, completion: @escaping (_ success: Bool, _ data: Data?, _ error: Error?) -> ()) {
        // Add URL parameters
        let urlParams = [
            "input": address,
            "types": "geocode",
            "language": "fr",
            "key": apiKey,
            ]
        
        // Fetch Request
        Alamofire.request("https://maps.googleapis.com/maps/api/place/autocomplete/json", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    completion(true, response.data!, nil)
                }
                else {
                    completion(false, nil, response.result.error)
                }
        }
    }
    
    public func getGeocodeAddress(address: String, completion: @escaping (_ success: Bool, _ data: Data?, _ error: Error?) -> ()) {
        // Add URL parameters
        let urlParams = [
            "address": address,
            "key": apiKey,
            ]
        
        // Fetch Request
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    completion(true, response.data!, nil)
                }
                else {
                    completion(false, nil, response.result.error)
                }
        }
    }
    
    public func getGeocodeLatlng(lat: String, lng: String, completion: @escaping (_ success: Bool, _ data: Data?, _ error: Error?) -> ()) {
        // Add URL parameters
        let urlParams = [
            "latlng": lat + "," + lng,
            "key": apiKey,
            ]
        
        // Fetch Request
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    completion(true, response.data!, nil)
                }
                else {
                    completion(false, nil, response.result.error)
                }
        }
    }
}

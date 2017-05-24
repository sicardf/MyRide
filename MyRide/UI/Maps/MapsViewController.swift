//
//  MapsViewController.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import Mapbox
import Alamofire
import SwiftyJSON

class MapsViewController: UIViewController, SearchAddressDelegate {

    private var mapboxView: MapboxView!
    private var searchAddressView: SearchAddressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        mapboxView = MapboxView(frame: view.frame)
        view.addSubview(mapboxView)
        
        searchAddressView = SearchAddressView(frame: CGRect(x: 20, y: 30, width: self.view.frame.size.width - 40, height: 250))
        searchAddressView.delegate = self
        view.addSubview(searchAddressView)
    }
    
    // MARK : SearchAddressDelegate
    
    func editTextField(address: String) {
        getPlaceAutocomplete(address: address)
    }
    
    func getAddressMap(address: String) {
        getGeocodeLatlng(address: address)
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    func getPlaceAutocomplete(address: String) {
        // Add URL parameters
        let urlParams = [
            "input": address,
            "types":"geocode",
            "language":"fr",
            "key":"AIzaSyA_Xk2H8wE-EFouzOlN56U41U4pkl6-K5U",
            ]
        
        // Fetch Request
        Alamofire.request("https://maps.googleapis.com/maps/api/place/autocomplete/json", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    self.searchAddressView.updateAutoCompletion(json: JSON(response.data!))
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error!)")
                }
        }
    }
    
    func getGeocodeLatlng(address: String) {
        // Add URL parameters
        let urlParams = [
            "address": address,
            "key":"AIzaSyA_Xk2H8wE-EFouzOlN56U41U4pkl6-K5U",
            ]
        
        // Fetch Request
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = JSON(response.data as Any)
                    let lat: Double = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                    let lng = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                    self.mapboxView.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    self.mapboxView.addPin()
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error!)")
                }
        }
    }
    
    


}

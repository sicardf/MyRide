//
//  MapsViewController.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import Mapbox
import SwiftyJSON

class MapsViewController: UIViewController, SearchAddressDelegate {

    private var mapboxView: MapboxView!
    private var searchAddressView: SearchAddressView!
    private let apiGoogle = APIGoogle()
    
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
    
    private func alertView(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK : SearchAddressDelegate
    
    func editTextField(address: String) {
        apiGoogle.getPlaceAutocomplete(address: address) { (success, data, error) in
            if success {
                self.searchAddressView.updateAutoCompletion(json: JSON(data!))
            } else {
                self.view.endEditing(true)
                self.alertView(message: error!.localizedDescription as String)
            }
        }
    }
    
    func getAddressMap(address: String) {
        apiGoogle.getGeocodeLatlng(address: address) { (success, data, error) in
            self.view.endEditing(true)
            if success {
                let json = JSON(data!)
                let lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let lng = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                self.mapboxView.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.mapboxView.addPin()
            } else {
                self.alertView(message: error!.localizedDescription as String)
            }
        }
    }

}

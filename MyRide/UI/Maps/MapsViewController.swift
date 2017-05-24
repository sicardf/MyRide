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

class MapsViewController: UIViewController, SearchAddressDelegate, MapDelegate {

    private var mapboxView: MapboxView!
    private var searchAddressView: SearchAddressView!
    private let apiGoogle = APIGoogle()
    
    private let controller = SideMenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        mapboxView = MapboxView(frame: view.frame)
        mapboxView.delegate = self
        view.addSubview(mapboxView)
        
        searchAddressView = SearchAddressView(frame: CGRect(x: 20, y: 30, width: self.view.frame.size.width - 40, height: 250))
        searchAddressView.delegate = self
        view.addSubview(searchAddressView)
        
        
      print("BEFOOOORE0")
        addChildViewController(self.controller)
         print("BEFOOOORE1")
        self.controller.view.frame = CGRect(x: -self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
         print("BEFOOOORE2")
        view.addSubview(self.controller.view)
         print("BEFOOOORE3")
        self.controller.didMove(toParentViewController: self)
        print("after")
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
        apiGoogle.getGeocodeAddress(address: address) { (success, data, error) in
            self.view.endEditing(true)
            if success {
                let json = JSON(data!)
                let lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let lng = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                self.mapboxView.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.mapboxView.pinIsHidden = false
                
                /*UIView.animate(withDuration: 0.5, animations: {
                    self.controller.view.frame.origin.x = 0
                }) { (bool) in
                    print("FINISH")
                }*/
            } else {
                self.alertView(message: error!.localizedDescription as String)
            }
        }
    }
    
    func displayMenu() {
        self.controller.displayMenu()
    }
    
    // MARK : MapDelegate
    
    func centerCoordinateMapChange(coordinate: CLLocationCoordinate2D) {
        let addressTmp = self.searchAddressView.address
        self.searchAddressView.address = "Update of location ..."
        apiGoogle.getGeocodeLatlng(lat: String(coordinate.latitude), lng: String(coordinate.longitude)) { (success, data, error) in
            if success {
                let json = JSON(data!)
                self.searchAddressView.address = json["results"][0]["formatted_address"].stringValue
            } else {
                self.searchAddressView.address = addressTmp
                self.alertView(message: error!.localizedDescription as String)
            }
        }
    }

}

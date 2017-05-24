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
import CoreData

class MapsViewController: UIViewController, SearchAddressDelegate, MapDelegate {

   // private var mapboxView: MapboxView!
    private var mapView:MapView!
    
    
    private var searchAddressView: SearchAddressView!
    private let apiGoogle = APIGoogle()
    
    private let sideMenuController = SideMenuViewController()
    
    var history: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        mapView = MapboxView(frame: view.frame) //MapboxView(frame: view.frame) - MapKitView(frame: view.frame)
        mapView.delegate = self
        view.addSubview(mapView)
        
        searchAddressView = SearchAddressView(frame: CGRect(x: 20, y: 30, width: self.view.frame.size.width - 40, height: 250))
        searchAddressView.delegate = self
        view.addSubview(searchAddressView)
        
        addSideMenuController()
    }
    
    private func addSideMenuController() {
        addChildViewController(self.sideMenuController)
        self.sideMenuController.view.frame = CGRect(x: -self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        view.addSubview(self.sideMenuController.view)
        self.sideMenuController.didMove(toParentViewController: self)
        self.sideMenuController.mapsViewController = self
    }
    
    private func alertView(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveHistory(address: String, lat: String, lng: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: managedContext)!
        let ride = NSManagedObject(entity: entity, insertInto: managedContext)
        ride.setValue(address, forKeyPath: "address")
        ride.setValue(lat, forKeyPath: "lat")
        ride.setValue(lng, forKeyPath: "lng")
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        
        do {
            history = try managedContext.fetch(fetchRequest)
            if history.count == 16 {
                appDelegate.managedObjectContext.delete(history[0])
            }
            try managedContext.save()
            history.append(ride)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

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
                self.saveHistory(address: address, lat: String(lat), lng: String(lng))
                
                self.mapView.changeCenterCoordinate(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                self.mapView.displayPin()
            } else {
                self.alertView(message: error!.localizedDescription as String)
            }
        }
    }
    
    func displayMenu() {
        self.sideMenuController.displayMenu()
    }
    
    // MARK : MapDelegate
    
    func centerCoordinateMapChange(coordinate: CLLocationCoordinate2D) {
        print("OCUOCUOC")
        let addressTmp = self.searchAddressView.address
        self.searchAddressView.address = "Update of location ..."
        apiGoogle.getGeocodeLatlng(lat: String(coordinate.latitude), lng: String(coordinate.longitude)) { (success, data, error) in
            if success {
                let json = JSON(data!)
                self.searchAddressView.address = json["results"][0]["formatted_address"].stringValue
                self.saveHistory(address: self.searchAddressView.address, lat: String(coordinate.latitude), lng: String(coordinate.longitude))
            } else {
                self.searchAddressView.address = addressTmp
                self.alertView(message: error!.localizedDescription as String)
            }
        }
    }
    
    func updateLocation(address: String, lat: Double, lng: Double) {
        searchAddressView.address = address
        
        self.mapView.changeCenterCoordinate(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        self.mapView.displayPin()
    }

}

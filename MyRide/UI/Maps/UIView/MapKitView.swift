//
//  ApplePlan.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import MapKit

class MapKitView: MapView, MKMapViewDelegate {
    
    private var mapView: MKMapView!
    private var pinView: UIImageView!
    var _delegate: MapDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func displayPin() {}
    
    override func changeCenterCoordinate(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        mapView = MKMapView(frame: self.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: false)
        
        addSubview(mapView)

        let pinView = UIImageView(frame: CGRect(x: self.frame.size.width / 2 - 25, y: self.frame.size.height / 2 - 50, width: 50, height: 50))
        pinView.image = #imageLiteral(resourceName: "pinIcon")
        addSubview(pinView)
    }
    
    // MARK : MGLMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        displayPin()
        print(mapView.centerCoordinate)
        delegate.centerCoordinateMapChange(coordinate: mapView.centerCoordinate)
    }
    
}

//
//  MapboxView.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import Mapbox

class MapboxView: MapView, MGLMapViewDelegate {

    private var mapView: MGLMapView!
    private var pinView: UIImageView!
    var _delegate: MapDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func displayPin() {}
    
    override func changeCenterCoordinate(coordinate: CLLocationCoordinate2D) {
        mapView.centerCoordinate = coordinate
        mapView.zoomLevel = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        mapView = MGLMapView(frame: self.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        addSubview(mapView)
        
        let pinView = UIImageView(frame: CGRect(x: self.frame.size.width / 2 - 25, y: self.frame.size.height / 2 - 50, width: 50, height: 50))
        pinView.image = #imageLiteral(resourceName: "pinIcon")
        addSubview(pinView)
    }
    
    // MARK : MGLMapViewDelegate
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
        delegate.centerCoordinateMapChange(coordinate: mapView.centerCoordinate)
    }

}

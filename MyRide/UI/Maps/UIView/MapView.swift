//
//  MapView.swift
//  MyRide
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import UIKit
import Mapbox

protocol MapDelegate {
    func centerCoordinateMapChange(coordinate: CLLocationCoordinate2D)
}

class MapView: UIView {
    
    var delegate: MapDelegate!
    
    func displayPin() {}
    func changeCenterCoordinate(coordinate: CLLocationCoordinate2D) {}
}

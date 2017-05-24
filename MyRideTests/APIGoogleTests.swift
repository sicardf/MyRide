//
//  APIGoogleTests.swift
//  
//
//  Created by Flavien SICARD on 24/05/2017.
//
//

import XCTest
@testable import SwiftyJSON
@testable import MyRide

class APIGoogleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestAutocomplete() {
        let apiGoogle = APIGoogle()
        let expectedId = "f61ae52b5e603c5052cc1aec9f08768c86090aba"
        
        apiGoogle.getPlaceAutocomplete(address: "12 route de la gare 13570 Barbentane") { (success, data, error) in
            if success {
                let result = JSON(data!)["predictions"][0]["id"].stringValue
                XCTAssert(result == expectedId)
            } else {
                
            }
        }
    }
    
    func testRequestGeocodeAddress() {
        let apiGoogle = APIGoogle()
        let expectedId = "ChIJh2zX_5fptRIRvOdzzkDCF-M"
        
        apiGoogle.getGeocodeAddress(address: "12 route de la gare 13570 Barbentane") { (success, data, error) in
            if success {
                let result = JSON(data!)["predictions"][0]["place_id"].stringValue
                XCTAssert(result == expectedId)
            } else {
                
            }
        }
    }
    
    func testRequestGeocodeLatlng() {
        let apiGoogle = APIGoogle()
        let expectedId = "40 Rue Colin, 34000 Montpellier, France"
        
        apiGoogle.getGeocodeLatlng(lat: "43.601461515809419", lng: "3.8783112529422401") { (success, data, error) in
            if success {
                let result = JSON(data!)["predictions"][0]["formatted_address"].stringValue
                XCTAssert(result == expectedId)
            } else {
                
            }
        }
    }
    
}

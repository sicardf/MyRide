//
//  MyRideTests.swift
//  MyRideTests
//
//  Created by Flavien SICARD on 24/05/2017.
//  Copyright © 2017 sicardf. All rights reserved.
//

import XCTest
@testable import SwiftyJSON
@testable import MyRide

class MyRideTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

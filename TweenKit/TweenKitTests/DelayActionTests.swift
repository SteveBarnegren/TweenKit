//
//  DelayActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 27/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class DelayActionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDelayActionReportsCorrectDuration() {
        
        let duration = 5.0
        let action = DelayAction(duration: duration)
        XCTAssertEqualWithAccuracy(action.duration, duration, accuracy: 0.001)
    }
    
}

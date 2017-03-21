//
//  RunBlockActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class RunBlockActionTests: XCTestCase {
    
    func testClosureIsInvoked() {
        
        var wasInvoked = false
        
        let action = RunBlockAction {
            wasInvoked = true
        }
        
        action.trigger()
        action.willBecomeActive()
        
        XCTAssertTrue(wasInvoked)
    }
    
    func testClosureCanBeInvokedMultipleTimes() {
        
        let numTimes = 10
        
        var numTimesInvoked = 0
        
        let action = RunBlockAction { 
            numTimesInvoked += 1
        }
        
        (0..<numTimes).forEach{ _ in
            action.trigger()
        }
        
        XCTAssertEqual(numTimesInvoked, numTimes)
    }
    
    
}

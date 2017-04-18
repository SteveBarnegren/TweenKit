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
    
    // MARK: - Test Trigger Closure
    
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
    
    // MARK: - Active / Inactive closures
    
    func testRepeatActionOnBecomeActiveClosureIsCalled() {
        
        var numCalls = 0
        let runBlock = FiniteTimeActionMock(duration: 1.0)
        runBlock.onBecomeActive = {
            numCalls += 1
        }
        runBlock.willBecomeActive()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testRepeatActionOnBecomeInactiveClosureIsCalled() {
        
        var numCalls = 0
        let runBlock = FiniteTimeActionMock(duration: 1.0)
        runBlock.onBecomeInactive = {
            numCalls += 1
        }
        runBlock.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }

    
    
}

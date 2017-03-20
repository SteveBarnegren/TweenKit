//
//  RepeatActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class RepeatActionTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        
        scheduler = Scheduler()
    }
    
    func testRepeatActionIsExpectedLength() {
        
        let numRepeats = 3
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: {_ in})
        let repeatedAction = RepeatAction(action: action, times: numRepeats)
        
        XCTAssertEqualWithAccuracy(action.duration * Double(numRepeats), repeatedAction.duration, accuracy: 0.001)
    }
    
    func testActionIsRunCorrectNumberOfTimes() {
        // TODO: 
        // After passing tests for call blocks
        // Repeat a sequence with call block and interpolate action, check block is called correct number of times
    }
}

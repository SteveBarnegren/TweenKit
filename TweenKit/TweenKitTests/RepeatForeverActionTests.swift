//
//  RepeatForeverActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class RepeatForeverActionTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        
        scheduler = Scheduler()
    }
    
    func testRepeatForeverActionIsNeverRemoved() {
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5, update: {_ in} ).repeatedForever()
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        
        self.scheduler.stepTime(duration: 10000, stepSize: 100)
        
        XCTAssertEqual(scheduler.numRunningAnimations, 1)
    }
    
    func testRepeatedForeverActionStillUpdatesActionAfterLongDuration() {
        
        let actionDuration = 5.0
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: actionDuration, update: { value = $0 } ).repeatedForever()
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        
        // Run for a long time
        self.scheduler.stepTime(duration: 10000.0, stepSize: 100.0)
        let firstReading = value

        // Step a short duration and confirm value is still changing
        self.scheduler.stepTime(duration: actionDuration/2)
        let secondReading = value
        
        // The readings should be about 0.5 apart
        XCTAssertNotEqualWithAccuracy(firstReading, secondReading, 0.3)
    }
    
}

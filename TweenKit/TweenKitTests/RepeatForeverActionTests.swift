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
    
    var scheduler: ActionScheduler!
    
    override func setUp() {
        super.setUp()
        
        scheduler = ActionScheduler()
    }
    
    // MARK: - Test Repeat Forever
    
    func testRepeatForeverActionIsNeverRemoved() {
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5, easing: .linear, update: {_ in} ).repeatedForever()
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        
        self.scheduler.progressTime(duration: 10000, stepSize: 100)
        
        XCTAssertEqual(scheduler.numRunningAnimations, 1)
    }
    
    func testRepeatedForeverActionStillUpdatesActionAfterLongDuration() {
        
        let actionDuration = 5.0
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: actionDuration, easing: .linear, update: { value = $0 } ).repeatedForever()
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        
        // Run for a long time
        self.scheduler.progressTime(duration: 10000.0, stepSize: 100.0)
        let firstReading = value

        // Step a short duration and confirm value is still changing
        self.scheduler.progressTime(duration: actionDuration/2)
        let secondReading = value
        
        // The readings should be about 0.5 apart
        XCTAssertNotEqualWithAccuracy(firstReading, secondReading, 0.3)
    }
    
    // MARK: - Test Inner Action LifeCycle Events
    
    func testRepeatForeverActionCallsExpectedInnerActionEvents() {
        
        let actionDuration = 0.1
        
        let action = FiniteTimeActionTester(duration: actionDuration)
        let repeatedForever = action.repeatedForever()
        let animation = Animation(action: repeatedForever)
        
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: actionDuration * 3.5)
        
        let expectedEvents: [EventType] = [.willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin
        ]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    func testRepeatForeverActionCallsExpectedInnerActionEventsWithStepSizeGreaterThanInnerActionDuration() {
        
        let action = FiniteTimeActionTester(duration: 1.0)
        let repeatedForever = action.repeatedForever()
        
        // Simulate a jump of 3.5 actions worth
        repeatedForever.willBecomeActive()
        repeatedForever.willBegin()
        repeatedForever.update(elapsedTime: action.duration * 3.5)
        
        let expectedEvents: [EventType] = [.willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin
        ]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
}

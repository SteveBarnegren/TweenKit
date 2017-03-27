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
        
        let action = FiniteTimeActionTester(duration: 0.1)
        let repeatedAction = action.repeated(3)
        
        let expectedEvents: [EventType] = [.willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive,
                                           ]
        
        let animation = Animation(action: repeatedAction)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: repeatedAction.duration + 0.1)
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    // MARK: - Inner Action Life
    
    func testInnerActionExpectedLifeCycleEventsAreCalled() {
        
        let action = FiniteTimeActionTester(duration: 5.0)
        let repeated = action.repeated(3)
        repeated.simulateFullLifeCycle()
        
        let expectedEvents: [EventType] = [.willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    func testInnerActionExpectedLifeCycleEventsAreCalledWhenReversed() {
        
        let action = FiniteTimeActionTester(duration: 5.0)
        let repeated = action.repeated(3)
        repeated.reverse = true
        repeated.simulateFullLifeCycle()
        
        let expectedEvents: [EventType] = [.setReversed(reversed: true),
                                           .willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }

    
    
    
}

//
//  ReverseActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 21/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class ReverseActionTests: XCTestCase {
    
    var scheduler: ActionScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = ActionScheduler(automaticallyAdvanceTime: false)
    }
    
    // MARK: - Test Duration
    
    func testReverseActionReportsSameDurationAsInnerAction() {
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear, update: { _ in} )
        let reversed = action.reversed()
        
        XCTAssertEqual(action.duration, reversed.duration, accuracy: 0.001)
    }
    
    // MARK: - Test Tweening
    
    func testReverseActionStartsAtActionEnd() {
        
        var value = 0.5
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear, update: { value = $0 })
        let reversed = action.reversed()
        
        reversed.willBecomeActive()
        reversed.willBegin()
        reversed.update(t: 0.0)
        
        XCTAssertEqual(value, 1.0, accuracy: 0.001)
    }
    
    func testReverseActionEndsAtActionStart() {
        
        var value = 0.5
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear, update: { value = $0 })
        let reversed = action.reversed()
        
        reversed.willBecomeActive()
        reversed.willBegin()
        reversed.update(t: 1.0)
        
        XCTAssertEqual(value, 0.0, accuracy: 0.001)
    }
    
    // MARK: - Test LifeCycle
    
    func testReverseActionInnerActionReceivesCorrectLifeCycleEvents() {
        
        let action = FiniteTimeActionMock(duration: 5.0)
        let reversed = action.reversed()
        reversed.simulateFullLifeCycle()
        
        let expectedEvents: [EventType] = [.setReversed(reversed: true),
                                           .willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    func testReverseActionInnerActionReceivesCorrectLifeCycleEventsWhenReversed() {
        
        let action = FiniteTimeActionMock(duration: 5.0)
        let reversed = action.reversed()
        reversed.reverse = true  // ==
        reversed.simulateFullLifeCycle()
        
        let expectedEvents: [EventType] = [.setReversed(reversed: true),
                                           .setReversed(reversed: false), // ==
                                           .willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    // MARK: - Active / Inactive closures
    
    func testReverseActionOnBecomeActiveClosureIsCalled() {
        
        var numCalls = 0
        let inner = FiniteTimeActionMock(duration: 1.0)
        let reversed = inner.reversed()
        reversed.onBecomeActive = {
            numCalls += 1
        }
        reversed.willBecomeActive()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testReverseActionOnBecomeInactiveClosureIsCalled() {
        
        var numCalls = 0
        let inner = FiniteTimeActionMock(duration: 1.0)
        let reversed = inner.reversed()
        reversed.onBecomeInactive = {
            numCalls += 1
        }
        reversed.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }


}

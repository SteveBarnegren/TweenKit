//
//  GroupTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class GroupTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = Scheduler()
    }
    
    func testGroupHasExpectedDuration() {
        
        let oneSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, easing: .linear, update: { _ in })
        let twoSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear, update: { _ in })
        let threeSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, easing: .linear, update: { _ in })
        
        let group = ActionGroup(actions: oneSecondAction, twoSecondAction, threeSecondAction)
        XCTAssertEqualWithAccuracy(group.duration, 3.0, accuracy: 0.001)
    }
    
    func testAllActionsComplete() {
        
        var firstValue = 0.0
        var secondValue = 0.0
        var thirdValue = 0.0
        
        let firstAction = InterpolationAction(from: 0.0, to: 1.0, duration: 0.1, easing: .linear, update: { firstValue = $0 })
        let secondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 0.2, easing: .linear, update: { secondValue = $0 })
        let thirdAction = InterpolationAction(from: 0.0, to: 1.0, duration: 0.3, easing: .linear, update: { thirdValue = $0 })
        
        let group = ActionGroup(actions: firstAction, secondAction, thirdAction)
        let animation = Animation(action: group)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: group.duration + 0.1)
        
        XCTAssertEqualWithAccuracy(firstValue, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(secondValue, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(thirdValue, 1.0, accuracy: 0.001)
    }
    
    func testRunBlockActionsAreRunAtBeginning() {
        
        var wasInvoked = false
        
        let interpolate = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear, update: { _ in })
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = ActionGroup(actions: interpolate, runBlock)
        
        // Test is run at the beginning
        group.willBecomeActive()
        group.willBegin()
        XCTAssertTrue(wasInvoked)
        
        // Test is not run at the end
        wasInvoked = false
        group.didFinish()
        group.didBecomeInactive()
        XCTAssertFalse(wasInvoked)
    }
    
    func testRunBlockActionAreRunAtEndInReverse() {
        
        var wasInvoked = false

        let interpolate = FiniteTimeActionTester(duration: 1.0)
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = ActionGroup(actions: interpolate, runBlock)
        group.reverse = true

        // Test is not run at the beginning
        group.willBecomeActive()
        group.willBegin()
        XCTAssertFalse(wasInvoked)
        
        // Test is run at the end
        wasInvoked = false
        group.didFinish()
        group.didBecomeInactive()
        XCTAssertTrue(wasInvoked)
    }
    
    // MARK: - Test LifeCycle
    
    func testExpectedInnerActionsLifeCycleEventsAreCalled() {
        
        let firstAction = FiniteTimeActionTester(duration: 0.1)
        let secondAction = FiniteTimeActionTester(duration: 0.2)
        let group = ActionGroup(actions: firstAction, secondAction)
        group.simulateFullLifeCycle()
        
        let expectedEvents: [EventType] = [.willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive,
                                           ]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: firstAction.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: secondAction.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    func testExpectedInnerActionsLifeCycleEventsAreCalledWhenReversed() {
        
        let firstAction = FiniteTimeActionTester(duration: 0.1)
        let secondAction = FiniteTimeActionTester(duration: 0.2)
        let group = ActionGroup(actions: firstAction, secondAction)
        group.reverse = true
        group.simulateFullLifeCycle()
        
        let expectedEvents: [EventType] = [.setReversed(reversed: true),
                                           .willBecomeActive,
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive,
                                           ]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: firstAction.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: secondAction.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
        
    }
    
    func testGroupFullLifeCycleUpdatesInnerActions() {
        
        var value1 = 0.0, value2 = 0.0, value3 = 0.0
        
        let action1 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.1, easing: .linear, update: { value1 = $0 })
        let action2 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.2, easing: .linear, update: { value2 = $0 })
        let action3 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.3, easing: .linear, update: { value3 = $0 })
        
        let group = ActionGroup(actions: action1, action2, action3)
        group.simulateFullLifeCycle()
        
        XCTAssertEqualWithAccuracy(value1, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(value2, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(value3, 1.0, accuracy: 0.001)
    }
    
    func testGroupFullLifeCycleUpdatesInnerActionsWhenReversed() {
        
        var value1 = 0.0, value2 = 0.0, value3 = 0.0
        
        let action1 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.1, easing: .linear, update: { value1 = $0 })
        let action2 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.2, easing: .linear, update: { value2 = $0 })
        let action3 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.3, easing: .linear, update: { value3 = $0 })
        
        let group = ActionGroup(actions: action1, action2, action3)
        group.reverse = true
        group.simulateFullLifeCycle()
        
        XCTAssertEqualWithAccuracy(value1, 0.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(value2, 0.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(value3, 0.0, accuracy: 0.001)
    }
    
    // MARK: - Active / Inactive closures
    
    func testGroupActionOnBecomeActiveClosureIsCalled() {
        
        var numCalls = 0
        let inner1 = FiniteTimeActionTester(duration: 1.0)
        let inner2 = FiniteTimeActionTester(duration: 1.0)
        let group = ActionGroup(actions: inner1, inner2)
        group.onBecomeActive = {
            numCalls += 1
        }
        group.willBecomeActive()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testGroupActionOnBecomeInactiveClosureIsCalled() {
        
        var numCalls = 0
        let inner1 = FiniteTimeActionTester(duration: 1.0)
        let inner2 = FiniteTimeActionTester(duration: 1.0)
        let group = ActionGroup(actions: inner1, inner2)
        group.onBecomeInactive = {
            numCalls += 1
        }
        group.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }
    
}

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
        
        let oneSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, update: { _ in })
        let twoSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, update: { _ in })
        let threeSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, update: { _ in })
        
        let group = Group(actions: oneSecondAction, twoSecondAction, threeSecondAction)
        XCTAssertEqualWithAccuracy(group.duration, 3.0, accuracy: 0.001)
    }
    
    func testAllActionsComplete() {
        
        var firstValue = 0.0
        var secondValue = 0.0
        var thirdValue = 0.0
        
        let firstAction = InterpolationAction(from: 0.0, to: 1.0, duration: 0.1, update: { firstValue = $0 })
        let secondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 0.2, update: { secondValue = $0 })
        let thirdAction = InterpolationAction(from: 0.0, to: 1.0, duration: 0.3, update: { thirdValue = $0 })
        
        let group = Group(actions: firstAction, secondAction, thirdAction)
        let animation = Animation(action: group)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: group.duration + 0.1)
        
        XCTAssertEqualWithAccuracy(firstValue, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(secondValue, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(thirdValue, 1.0, accuracy: 0.001)
    }
    
    func testRunBlockActionsAreRunAtBeginning() {
        
        var wasInvoked = false
        
        let interpolate = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { _ in })
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = Group(actions: interpolate, runBlock)
        
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

        let interpolate = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { _ in })
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = Group(actions: interpolate, runBlock)
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
    
    func testExpectedInnerActionsLifeCycleEventsAreCalled() {
        
        let firstAction = FiniteTimeActionTester(duration: 0.1)
        let secondAction = FiniteTimeActionTester(duration: 0.2)
        let group = Group(actions: firstAction, secondAction)
        let animation = Animation(action: group)
        
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: group.duration + 0.1)
        
        let expectedEvents: [FiniteTimeActionTester.EventType] = [.willBecomeActive,
                                                                  .willBegin,
                                                                  .didFinish,
                                                                  .didBecomeInactive,
                                                                  ]
        
        let firstActionEvents = firstAction.loggedEventsOfTypes(expectedEvents)
        XCTAssertEqual(expectedEvents, firstActionEvents)
        
        let secondActionEvents = secondAction.loggedEventsOfTypes(expectedEvents)
        XCTAssertEqual(expectedEvents, secondActionEvents)
    }
    
    func testExpectedInnerActionsLifeCycleEventsAreCalledWhenReversed() {
        
        let firstAction = FiniteTimeActionTester(duration: 0.1)
        firstAction.tag = 1
        let secondAction = FiniteTimeActionTester(duration: 0.2)
        let reversedGroup = Group(actions: firstAction, secondAction).reversed()
        let animation = Animation(action: reversedGroup)
        
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: reversedGroup.duration + 0.1)
        
        let expectedEvents: [FiniteTimeActionTester.EventType] = [.willBecomeActive,
                                                                  .willBegin,
                                                                  .didFinish,
                                                                  .didBecomeInactive,
                                                                  ]
        
        let firstActionEvents = firstAction.loggedEventsOfTypes(expectedEvents)
        XCTAssertEqual(expectedEvents, firstActionEvents)
        
        //let secondActionEvents = secondAction.loggedEventsOfTypes(expectedEvents)
        //XCTAssertEqual(expectedEvents, secondActionEvents)
    }

    
    
    
    
    
}

//
//  YoyoActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class YoyoActionTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        
        scheduler = Scheduler()
    }
    
    func testDurationIsDoubleInnerAction() {
        
        let inner = InterpolationAction(from: 0, to: 1, duration: 5, update: { _ in })
        let yoyo = YoyoAction(action: inner)
        
        XCTAssertEqualWithAccuracy(inner.duration * 2, yoyo.duration, accuracy: 0.001)
    }
    
    func testMidPointIsEndOfAction() {
        
        let start = 1.0
        let end = 3.0
        let duration = 5.0
        
        var value = 0.0
        let yoyo = InterpolationAction(from: start, to: end, duration: duration, update: {value = $0} ).yoyo()
        
        yoyo.willBecomeActive()
        yoyo.willBegin()
        yoyo.update(t: 0.5)
        
        XCTAssertEqualWithAccuracy(value, end, accuracy: 0.001)
    }
    
    func testEndPointIsBeginningOfAction() {
        
        let start = 1.0
        let end = 3.0
        let duration = 5.0
        
        var value = 0.0
        let yoyo = InterpolationAction(from: start, to: end, duration: duration, update: {value = $0} ).yoyo()
        
        yoyo.willBecomeActive()
        yoyo.willBegin()
        yoyo.update(t: 1)
        
        XCTAssertEqualWithAccuracy(value, start, accuracy: 0.001)
    }
    
    func testOnFinishUpdatesInnerAction() {
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: {value = $0})
        let yoyo = action.yoyo()
        yoyo.simulateFullLifeCycle()
        XCTAssertEqualWithAccuracy(value, 0.0, accuracy: 0.001)
    }
    
    func testInnerActionEventOrder() {
        
        let expectedEvents: [EventType] = [.willBecomeActive,
                                           .setReversed(reversed: false),
                                           .willBegin,
                                           .didFinish,
                                           .setReversed(reversed: true),
                                           .willBegin,
                                           .didFinish,
                                           .didBecomeInactive]
        
        let duration = 0.1
        let action = FiniteTimeActionTester(duration: duration)
        let yoyo = action.yoyo()
        let animation = Animation(action: yoyo)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: yoyo.duration + 0.1)
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: action.loggedEvents,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
}

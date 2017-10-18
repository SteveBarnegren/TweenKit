//
//  InterpolateActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class InterpolateActionTests: XCTestCase {
    
    var scheduler: ActionScheduler!
    let tempValue = 0.90
    
    override func setUp() {
        super.setUp()
        scheduler = ActionScheduler()
    }
    
    // MARK: - Tweening
    
    func testInterpolateActionFromClosureSetsStartValue() {
        
        let startValue = 6.23
        var updatedValue = 0.0
        let action = InterpolationAction(from: { startValue }, to: Double(1.0), duration: 1.0, easing: .linear, update: { updatedValue = $0 })
        
        action.willBecomeActive()
        action.willBegin()
        action.update(t: 0.0)
        
        XCTAssertEqual(updatedValue, startValue, accuracy: 0.001)
    }
    
    func testInterpolateActionEndsWithEndValue() {
        
        let duration = 0.1
        let expectedEndValue = 12.0
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: expectedEndValue, duration: duration, easing: .linear) {
            value = $0
        }
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: duration + 0.1)
        
        XCTAssertEqual(value, expectedEndValue, accuracy: 0.001)
    }
    
    func testInterpolateActionEndsWithStartValueReversed() {
        
        let duration = 0.1
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: duration, easing: .linear) { value = $0 }
        action.reverse = true
        
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: duration + 0.1)
        
        XCTAssertEqual(value, 0.0, accuracy: 0.001)
    }
    
    // MARK: - LifeCycle
    
    func testInterpolateActionFullLifeCycleResultsInExpectedEndValue() {

        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear) { value = $0 }
        action.simulateFullLifeCycle()
        XCTAssertEqual(value, 1.0, accuracy: 0.001)
    }
    
    func testInterpolateActionFullLifeCycleResultsInExpectedEndValueWhenReversed() {
        
        var value = 0.0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear) { value = $0 }
        action.reverse = true
        action.simulateFullLifeCycle()
        XCTAssertEqual(value, 0.0, accuracy: 0.001)
    }
    
    // MARK: - Active / Inactive closures
    
    func testInterpolateActionOnBecomeActiveClosureIsCalled() {
        
        var numCalls = 0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, easing: .linear, update: { _ in })
        action.onBecomeActive = {
            numCalls += 1
        }
        action.willBecomeActive()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testInterpolateActionOnBecomeInactiveClosureIsCalled() {
        
        var numCalls = 0
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, easing: .linear, update: { _ in })
        action.onBecomeInactive = {
            numCalls += 1
        }
        action.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }

}

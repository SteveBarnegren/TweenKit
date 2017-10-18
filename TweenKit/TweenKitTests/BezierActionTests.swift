//
//  BezierActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 28/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class BezierActionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Duration
    
    func testBezierActionReportsCorrectDuration() {
        
        let duration = 5.0
        
        let path = makeBasicTestPath()
        let action = BezierAction(path: path,
                                  duration: duration,
                                  update: {_,_  in})
        
        XCTAssertEqual(action.duration, duration, accuracy: 0.001)
    }
    
    
    // MARK: - LifeCycle
    
    func testBezierActionLifeCycleUpdatesValue() {
        
        var value = CGPoint.zero
        let startPoint = CGPoint(x: 50, y: 50)
        let endPoint = CGPoint(x: 100, y: 100)
        
        let path = BezierPath(start: startPoint,
                              curves: [.lineToPoint(endPoint)])
        
        let action = BezierAction(path: path,
                                  duration: 5.0,
                                  update: { (pos, _) in value = pos })
        action.simulateFullLifeCycle()
        
        AssertCGPointsAreEqualWithAccuracy(value, endPoint, accuracy: 0.001)
    }
    
    func testBezierActionLifeCycleUpdatesValueWhenReversed() {
        
        var value = CGPoint.zero
        let startPoint = CGPoint(x: 50, y: 50)
        let endPoint = CGPoint(x: 100, y: 100)
        
        let path = BezierPath(start: startPoint,
                              curves: [.lineToPoint(endPoint)])
        
        let action = BezierAction(path: path,
                                  duration: 5.0,
                                  update: { (pos, _) in value = pos })
        action.reverse = true
        action.simulateFullLifeCycle()
        
        AssertCGPointsAreEqualWithAccuracy(value, startPoint, accuracy: 0.001)
    }
    
    // MARK: - Active / Inactive closures
    
    func testBezierActionOnBecomeActiveClosureIsCalled() {
        
        var numCalls = 0
        let path = makeBasicTestPath()
        let action = BezierAction(path: path,
                                  duration: 1.0,
                                  update: {_,_  in})
        action.onBecomeActive = {
            numCalls += 1
        }
        action.willBecomeActive()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testBezierActionOnBecomeInactiveClosureIsCalled() {
        
        var numCalls = 0
        let path = makeBasicTestPath()
        let action = BezierAction(path: path,
                                  duration: 1.0,
                                  update: {_,_  in})
        action.onBecomeInactive = {
            numCalls += 1
        }
        action.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }

    
    
    
}

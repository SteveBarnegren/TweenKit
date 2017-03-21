//
//  ShedulerTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class SchedulerTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = Scheduler()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSchedulerReturnsCorrectNumberOfAnimations() {
        
        func addAnimation() {
            let action = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, update: { _ in })
            let animation = Animation(action: action)
            scheduler.add(animation: animation)
        }
        
        XCTAssertEqual(scheduler.numRunningAnimations, 0)
        addAnimation()
        XCTAssertEqual(scheduler.numRunningAnimations, 1)
        addAnimation()
        XCTAssertEqual(scheduler.numRunningAnimations, 2)
        addAnimation()
        XCTAssertEqual(scheduler.numRunningAnimations, 3)
    }
    
    func testAnimationIsRemovedOnCompletion() {
        
        let duration = 0.1
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: duration) {_ in }
        let animation = Animation(action: action)
        scheduler.add(animation: animation)
        
        scheduler.progressTime(duration: duration + 0.1)
        XCTAssertEqual(scheduler.numRunningAnimations, 0)
    }
}

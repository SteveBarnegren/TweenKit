//
//  SequenceTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class SequenceTests: XCTestCase {
   
    var scheduler: ActionScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = ActionScheduler(automaticallyAdvanceTime: false)
    }
    
    func testDurationIsSumOfActionsDuration() {
        
        let action1 = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, easing: .linear, update: {_ in})
        let action2 = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear, update: {_ in})
        let action3 = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, easing: .linear, update: {_ in})
        let sequence = ActionSequence(actions: action1, action2, action3)
        
        let expectedDuration = action1.duration + action2.duration + action3.duration
        
        XCTAssertEqual(sequence.duration, expectedDuration, accuracy: 0.001)
    }
    
    func testActionsEventsAreCalledInExpectedOrder() {
        
        func makeBecomeActiveString(tag: Int) -> String { return "Become Active: \(tag)" }
        func makeBecomeInactiveString(tag: Int) -> String { return "Become Inactive: \(tag)" }
        func makeWillBeginString(tag: Int) -> String { return "Will Begin: \(tag)" }
        func makeDidFinishString(tag: Int) -> String { return "Did Finish: \(tag)" }

        var events = [String]()
        
        func makeAction(tag: Int) -> FiniteTimeActionMock {
            let action = FiniteTimeActionMock(duration: 0.1)
            action.onBecomeActive = { events.append(makeBecomeActiveString(tag: tag)) }
            action.onBecomeInactive = { events.append(makeBecomeInactiveString(tag: tag)) }
            action.onWillBegin = { events.append(makeWillBeginString(tag: tag)) }
            action.onDidFinish = { events.append(makeDidFinishString(tag: tag)) }
            return action
        }
        
        let action1 = makeAction(tag: 1)
        let action2 = makeAction(tag: 2)
        let action3 = makeAction(tag: 3)
        
        let sequence = ActionSequence(actions: action1, action2, action3)
        let animation = Animation(action: sequence)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: sequence.duration + 0.1)
        
        let expectedEvents: [String] = [makeBecomeActiveString(tag: 1),
                                        makeWillBeginString(tag: 1),
                                        makeDidFinishString(tag: 1),
                                        makeBecomeInactiveString(tag: 1),
                                        makeBecomeActiveString(tag: 2),
                                        makeWillBeginString(tag: 2),
                                        makeDidFinishString(tag: 2),
                                        makeBecomeInactiveString(tag: 2),
                                        makeBecomeActiveString(tag: 3),
                                        makeWillBeginString(tag: 3),
                                        makeDidFinishString(tag: 3),
                                        makeBecomeInactiveString(tag: 3),
                                        ]
        
        XCTAssertEqual(events, expectedEvents)
    }
    
    func testActionsEventsAreCalledInExpectedOrderWhenInReverseAction() {
        
        let eventLog = EventLog()
        
        let action1 = FiniteTimeActionMock(duration: 0.1, externalEventLog: eventLog, tag: 1)
        let action2 = FiniteTimeActionMock(duration: 0.2, externalEventLog: eventLog, tag: 2)
        let action3 = FiniteTimeActionMock(duration: 0.3, externalEventLog: eventLog, tag: 3)
        
        let sequence = ActionSequence(actions: action1, action2, action3)
        sequence.simulateFullLifeCycle()

        let expectedEvents: [EventType] = [.willBecomeActiveWithTag(1),
                                           .willBeginWithTag(1),
                                           .didFinishWithTag(1),
                                           .didBecomeInactiveWithTag(1),
                                           .willBecomeActiveWithTag(2),
                                           .willBeginWithTag(2),
                                           .didFinishWithTag(2),
                                           .didBecomeInactiveWithTag(2),
                                           .willBecomeActiveWithTag(3),
                                           .willBeginWithTag(3),
                                           .didFinishWithTag(3),
                                           .didBecomeInactiveWithTag(3),
                                           ]
        
        AssertLifeCycleEventsAreAsExpected(recordedEvents: eventLog.events,
                                           expectedEvents: expectedEvents,
                                           filter: .onlyMatchingExpectedEventsTypes)
    }
    
    func testAllActionsEndInCompletedStates() {
    
        var value1 = 0.0, value2 = 0.0, value3 = 0.0
        
        let action1 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.1, easing: .linear, update: { value1 = $0 })
        let action2 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.2, easing: .linear, update: { value2 = $0 })
        let action3 = InterpolationAction(from: 0.0, to: 1.0, duration: 0.3, easing: .linear, update: { value3 = $0 })

        let sequence = ActionSequence(actions: action1, action2, action3)
        let animation = Animation(action: sequence)
        scheduler.add(animation: animation)
        scheduler.progressTime(duration: sequence.duration + 0.1, stepSize: 0.05)
        
        XCTAssertEqual(value1, 1.0, accuracy: 0.001)
        XCTAssertEqual(value2, 1.0, accuracy: 0.001)
        XCTAssertEqual(value3, 1.0, accuracy: 0.001)
    }
    
    func testSequenceFullLifeCycleUpdatesInnerActions() {
        
        var value1 = 0.0, value2 = 0.0, value3 = 0.0
        
        let action1 = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, easing: .linear, update: { value1 = $0 })
        let action2 = InterpolationAction(from: 0.0, to: 1.0, duration: 4.0, easing: .linear, update: { value2 = $0 })
        let action3 = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear, update: { value3 = $0 })
        
        let sequence = ActionSequence(actions: action1, action2, action3)
        sequence.simulateFullLifeCycle()
        
        XCTAssertEqual(value1, 1.0, accuracy: 0.001)
        XCTAssertEqual(value2, 1.0, accuracy: 0.001)
        XCTAssertEqual(value3, 1.0, accuracy: 0.001)
    }
    
    func testSequenceFullLifeCycleUpdatesInnerActionsWhenReversed() {
        
        var value1 = 0.0, value2 = 0.0, value3 = 0.0
        
        let action1 = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, easing: .linear, update: { value1 = $0 })
        let action2 = InterpolationAction(from: 0.0, to: 1.0, duration: 4.0, easing: .linear, update: { value2 = $0 })
        let action3 = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, easing: .linear, update: { value3 = $0 })
        
        let sequence = ActionSequence(actions: action1, action2, action3)
        sequence.reverse = true
        sequence.simulateFullLifeCycle()
        
        XCTAssertEqual(value1, 0.0, accuracy: 0.001)
        XCTAssertEqual(value2, 0.0, accuracy: 0.001)
        XCTAssertEqual(value3, 0.0, accuracy: 0.001)
    }
    
    // MARK: - Active / Inactive closures
    
    func testSequenceActionOnBecomeActiveClosureIsCalled() {
        
        var numCalls = 0
        let inner1 = FiniteTimeActionMock(duration: 1.0)
        let inner2 = FiniteTimeActionMock(duration: 1.0)
        let sequence = ActionSequence(actions: inner1, inner2)
        sequence.onBecomeActive = {
            numCalls += 1
        }
        sequence.willBecomeActive()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testSequenceActionOnBecomeInactiveClosureIsCalled() {
        
        var numCalls = 0
        let inner1 = FiniteTimeActionMock(duration: 1.0)
        let inner2 = FiniteTimeActionMock(duration: 1.0)
        let sequence = ActionSequence(actions: inner1, inner2)
        sequence.onBecomeInactive = {
            numCalls += 1
        }
        sequence.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    // MARK: - Call Trigger Actions
    
    func testSequenceCallsTriggerActionAtBeginning() {
        
        var numCalls = 0
        
        let triggerAction = RunBlockAction(handler: { numCalls += 1 })
        let timeAction = FiniteTimeActionMock(duration: 1.0)
        
        let sequence = ActionSequence(actions: timeAction, triggerAction)
        sequence.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testSequenceCallsTriggerActionAtEnd() {
        
        var numCalls = 0
        
        let timeAction = FiniteTimeActionMock(duration: 1.0)
        let triggerAction = RunBlockAction(handler: { numCalls += 1 })
        
        let sequence = ActionSequence(actions: timeAction, triggerAction)
        sequence.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testSequenceCallsTriggerActionInMiddle() {
        
        var numCalls = 0
        
        let startAction = FiniteTimeActionMock(duration: 1.0)
        let triggerAction = RunBlockAction(handler: { numCalls += 1 })
        let endAction = FiniteTimeActionMock(duration: 1.0)
        
        let sequence = ActionSequence(actions: startAction, triggerAction, endAction)
        sequence.simulateFullLifeCycle()
        
        XCTAssertEqual(numCalls, 1)
    }
    
    func testSequenceCallsTriggerActionInMiddleWithSimulatedProgress() {
        
        var numCalls = 0
        
        let startAction = FiniteTimeActionMock(duration: 1.0)
        let triggerAction = RunBlockAction(handler: { numCalls += 1 })
        let endAction = FiniteTimeActionMock(duration: 1.0)
        
        let sequence = ActionSequence(actions: startAction, triggerAction, endAction)
        
        let scheduler = ActionScheduler(automaticallyAdvanceTime: false)
        scheduler.run(action: sequence)
        scheduler.progressTime(duration: sequence.duration + 0.1, stepSize: 0.5)
        
        XCTAssertEqual(numCalls, 1)
    }

}

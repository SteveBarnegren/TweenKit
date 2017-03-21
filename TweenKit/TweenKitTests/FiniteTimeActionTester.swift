
//
//  FiniteTimeActionTester.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
@testable import TweenKit


func ==(lhs: FiniteTimeActionTester.EventType, rhs: FiniteTimeActionTester.EventType) -> Bool {
    
    switch (lhs, rhs) {
    case (.willBegin, .willBegin):
        return true
    case (.didFinish, .didFinish):
        return true
    case (.willBecomeActive, .willBecomeActive):
        return true
    case (.didBecomeInactive, .didBecomeInactive):
        return true
    case (.setReversed(let leftValue), .setReversed(let rightValue)):
        return leftValue == rightValue
    default:
        return false
    }
}

class FiniteTimeActionTester: FiniteTimeAction {

    // Types
    enum EventType: Equatable {
        case willBegin
        case didFinish
        case willBecomeActive
        case didBecomeInactive
        case setReversed(reversed: Bool)
    }
    
    // MARK: - Init
 
    init(duration: Double) {
        self.duration = duration
    }
    
    // MARK: - Test State
    
    var loggedEvents = [EventType]()
    func loggedEventsOfTypes(_ eventsToMatch: [EventType]) -> [EventType] {
        
        func includeEvent(_ event: EventType) -> Bool {
            
            if event == .setReversed(reversed: true) || event == .setReversed(reversed: false) {
                return eventsToMatch.contains(.setReversed(reversed: true)) || eventsToMatch.contains(.setReversed(reversed: false))
            }
            else{
                return eventsToMatch.contains(event)
            }
        }
        
        return loggedEvents.filter{
            includeEvent($0)
        }
    }
    
    var willBeginCallCount = 0
    var has_WillBegin_BeenCalled: Bool {
        return willBeginCallCount > 0
    }
    
    var didFinishCallCount = 0
    var has_DidFinish_BeenCalled: Bool {
        return didFinishCallCount > 0
    }
    
    var willBecomeActiveCallCount = 0
    var has_WillBecomeActive_BeenCalled: Bool {
        return willBecomeActiveCallCount > 0
    }
    
    var didBecomeInactiveCallCount = 0
    var has_DidBecomeInactive_BeenCalled: Bool {
        return didBecomeInactiveCallCount > 0
    }
    
    var updateCalled = false
    
    var tag = 0
    
    var onWillBegin: () -> () = {}
    var onDidFinish: () -> () = {}
    
    // MARK: - FiniteTimeAction

    var duration: Double
    var reverse: Bool = false {
        didSet{
            loggedEvents.append(.setReversed(reversed: reverse))
        }
    }
    var onBecomeActive: () -> () = {}
    var onBecomeInactive: () -> () = {}
    
    func willBecomeActive() {
        loggedEvents.append(.willBecomeActive)
        willBecomeActiveCallCount += 1
        onBecomeActive()
        
        if tag == 0 {
            print("stop")
        }
    }
    
    func didBecomeInactive() {
        loggedEvents.append(.didBecomeInactive)
        didBecomeInactiveCallCount += 1
        onBecomeInactive()
    }
    
    func willBegin() {
        loggedEvents.append(.willBegin)
        willBeginCallCount += 1
        onWillBegin()
    }
    
    func didFinish() {
        loggedEvents.append(.didFinish)
        didFinishCallCount += 1
        onDidFinish()
    }

    
    public func update(t: CFTimeInterval) {
        updateCalled = true
    }
}

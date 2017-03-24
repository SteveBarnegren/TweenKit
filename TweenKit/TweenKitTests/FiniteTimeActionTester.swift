
//
//  FiniteTimeActionTester.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
@testable import TweenKit

// Types
enum EventType {
    case willBegin
    case willBeginWithTag(Int)
    
    case didFinish
    case didFinishWithTag(Int)
    
    case willBecomeActive
    case willBecomeActiveWithTag(Int)
    
    case didBecomeInactive
    case didBecomeInactiveWithTag(Int)
    
    case setReversed(reversed: Bool)
    case setReversedWithTag(Int, reversed: Bool)
    
    func asString() -> String {
        
        switch self {
        case .willBegin: return "Will Begin"
        case .willBeginWithTag(let tag): return "Will Begin (\(tag))"
        case .didFinish: return "Did Finish"
        case .didFinishWithTag(let tag): return "Did Finish (\(tag))"
        case .willBecomeActive: return "Will Become Active"
        case .willBecomeActiveWithTag(let tag): return "Will Become Active (\(tag))"
        case .didBecomeInactive: return "Did Become Inactive"
        case .didBecomeInactiveWithTag(let tag): return "Did Become Inactive (\(tag))"
        case .setReversed(let reversed): return "Set Reversed -> \(reversed)"
        case let .setReversedWithTag(tag, reversed): return "Set Reversed -> \(reversed) (\(tag)) "
        }
    }
}


class EventLog {
    
    private var loggedEvents = [EventType]()
    
    fileprivate func add(event: EventType) {
        loggedEvents.append(event)
    }
    
    var events: [EventType] {
        return loggedEvents
    }
}

class FiniteTimeActionTester: FiniteTimeAction {

    // MARK: - Init
 
    init(duration: Double) {
        self.duration = duration
    }
    
    init(duration: Double, externalEventLog: EventLog, tag: Int) {
        self.duration = duration
        self.sharedEventLog = externalEventLog
        self.tag = tag
    }
    
    // MARK: - Test State
    
    var loggedEvents = [EventType]()
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
    
    var onWillBegin: () -> () = {}
    var onDidFinish: () -> () = {}
    
    private var sharedEventLog: EventLog? = nil
    private var tag: Int = 0
    
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
        sharedEventLog?.add(event: .willBecomeActiveWithTag(tag))
        willBecomeActiveCallCount += 1
        onBecomeActive()
    }
    
    func didBecomeInactive() {
        loggedEvents.append(.didBecomeInactive)
        sharedEventLog?.add(event: .didBecomeInactiveWithTag(tag))
        didBecomeInactiveCallCount += 1
        onBecomeInactive()
    }
    
    func willBegin() {
        loggedEvents.append(.willBegin)
        sharedEventLog?.add(event: .willBeginWithTag(tag))
        willBeginCallCount += 1
        onWillBegin()
    }
    
    func didFinish() {
        loggedEvents.append(.didFinish)
        sharedEventLog?.add(event: .didFinishWithTag(tag))
        didFinishCallCount += 1
        onDidFinish()
    }

    
    public func update(t: CFTimeInterval) {
        updateCalled = true
    }
}

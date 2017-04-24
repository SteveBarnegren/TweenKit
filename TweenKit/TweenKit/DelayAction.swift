//
//  DelayAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Can be used to add a delay to a sequence */
public class DelayAction: FiniteTimeAction {
    
    // MARK: - Public
    
    /**
     Create with duration
     - Parameter duration: The duration of the deley
     */
    public init(duration: Double) {
        self.duration = duration
    }
    
    // MARK: - Properties
    
    public let duration: Double
    public var reverse = false
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    // MARK: - Methods
    
    public func willBecomeActive() {
        onBecomeActive()
    }
    
    public func didBecomeInactive() {
        onBecomeInactive()
    }
    
    public func willBegin() {
    }
    
    public func didFinish() {
    }
    
    public func update(t: CFTimeInterval) {
    }
}

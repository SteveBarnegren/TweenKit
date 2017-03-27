//
//  DelayAction.swift
//  TweenKit
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class DelayAction: FiniteTimeAction {
    
    // MARK: - Public
    
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

//
//  RunBlockAction.swift
//  TweenKit
//
//  Created by Steve Barnegren on 19/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/** Runs a block. Can be used to add callbacks in sequences */
public class RunBlockAction: TriggerAction {
    
    // MARK: - Public
    
    public var onBecomeActive: () -> () = {}
    public var onBecomeInactive: () -> () = {}
    
    /**
     Create with a callback closure
     - Parameter handler: The closure to call
     */
    public init(handler: @escaping () -> ()) {
        self.handler = handler
    }
    
    // MARK: - Private
    
    let handler: () -> ()
    public let duration = 0.0
    public var reverse: Bool = false
    
    public func trigger() {
        handler()
    }
    
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
        // Do nothing
    }
}

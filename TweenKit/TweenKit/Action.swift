//
//  Action.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class Action <T: Tweenable> {
    
    // MARK: - Properties
    
    public var startValue: T! // Make private - set in initialiser
    public var endValue: T! // Make private - set in initialiser
    
    public var updateHandler: (_: T) -> () = {_ in} // Make private - set in initialiser
    
    
    public init() {
    }
    
    // MARK: - Update

    public func updateWithTime(t: Double) { // Should this really be public?
        fatalError("Subclass must override")
    }
    
}
 



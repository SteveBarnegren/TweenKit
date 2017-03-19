//
//  Action.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public protocol SchedulableAction: class {
    func updateWithTime(t: CFTimeInterval)
    var duration: CFTimeInterval {get}
}



public class Action<T: Tweenable> : SchedulableAction {
    
    // MARK: - Properties
    public internal(set) var duration: CFTimeInterval = 0
    var updateHandler: (_: T) -> () = {_ in}
    
    public init() {
    }
    
    // MARK: - Schedulable
    
    public func updateWithTime(t: Double) {
        fatalError("Subclasses must override")
    }
}
 



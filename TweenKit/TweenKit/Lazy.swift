//
//  Lazy.swift
//  TweenKit
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/* 
 TLDR: Call .value on Lazy<T>, you will get the value you are looking for. (most likely a double)
 
 What is Lazy<T>, and why do we need it?
 
 Lazy<T> allows us to create a value, but defer its calculation until the point that it is used.
 In the event that the value is unused, then the calculation will be avoided entirely.

 eg. The BezierAction update handler supplys two arguments, position and rotation: () -> (position: Double, rotation: Lazy<Double>)
 
 Positon is quick to calculate, and will be used by the supplied closure in pretty much all cases.
 Rotation is a bit more intensive to calculate, and the closure might not even use it.
 Wrapping the calculation in Lazy<Double>, rotation will not be caluclated if rotation.value is never called.
 
 The result of the value is cached, so calling calling .value multiple times will only perform the calculation once
 */


/**
 Wrapper for long running calulations. Calculation will not be performed until .value is called.
 Caches result for sunsequent calls
 */
public class Lazy<T> {
    
    private indirect enum State<T> {
        case closure( () -> (T) )
        case value(T)
    }
    
    private var state: State<T>
    
    public init(calculate: @escaping () -> (T)) {
        self.state = .closure(calculate)
    }
    
    public var value : T {
        get {
            switch state {
            case .value(let value):
                return value
            case .closure(let closure):
                let result = closure()
                self.state = .value(result)
                return result
            }
        }
    }
}

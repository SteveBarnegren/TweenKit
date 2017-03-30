//
//  Lazy.swift
//  TweenKit
//
//  Created by Steven Barnegren on 30/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public class Lazy<T> {
    
    let calculateValue: () -> (T)
    var backing: T?
    
    init(calculate: @escaping () -> (T)) {
        self.calculateValue = calculate
    }
    
    public var value : T {
        get {
            if backing == nil {
                backing = calculateValue()
            }
            return backing!
        }
    }
}

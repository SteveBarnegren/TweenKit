//
//  Action.swift
//  TweenKit
//
//  Created by Steve Barnegren on 17/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public protocol SchedulableAction: class {
}

public protocol FiniteTimeAction : class {
    var duration: Double {get}
    var reverse: Bool {get set}
    func update(t: CFTimeInterval)
}

public protocol InfiniteTimeAction : class {
    func update(elapsedTime: CFTimeInterval)
}



 



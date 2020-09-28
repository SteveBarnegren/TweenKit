//
//  Scheduler.swift
//  TweenKit
//
//  Created by Steve Barnegren on 18/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation
import QuartzCore

@objc public class ActionScheduler : NSObject {
    
    // MARK: - Public
        
    public init(automaticallyAdvanceTime: Bool = true) {
        self.automaticallyAdvanceTime = automaticallyAdvanceTime
        super.init()
    }
    
    /**
    Run an action
    - Parameter action: The action to run
    - Returns: Animation instance. You may wish to keep this, so that you can remove the animation later using the remove(animation:) method
    */
    @discardableResult public func run(action: SchedulableAction) -> Animation {
        let animation = Animation(action: action)
        add(animation: animation)
        return animation
    }
    
    /**
     Adds an Animation to the scheduler. Usually you don't need to construct animations yourself, you can run the action directly.
     - Parameter animation: The animation to run
     */
    public func add(animation: Animation) {
        animations.append(animation)
        animation.willStart()
        
        if automaticallyAdvanceTime {
            startLoop()
        }
    }
    
    /**
     Removes a currently running animation
     - Parameter animation: The animation to remove
     */
    public func remove(animation: Animation) {
        
        guard let index = animations.firstIndex(of: animation) else {
            print("Can't find animation to remove")
            return
        }
        
        animation.didFinish()
        animations.remove(at: index)
        
        if animations.isEmpty {
            stopLoop()
        }
    }
    
    /**
     Removes all animations
     */
    public func removeAll() {
        
        let allAnimations = animations
        allAnimations.forEach{
            self.remove(animation: $0)
        }
    }
    
    /**
     The number of animations that are currently running
     */
    public var numRunningAnimations: Int {
        return self.animations.count
    }

    // MARK: - Properties
    
    private var animations = [Animation]()
    private var animationsToRemove = [Animation]()

    private var displayLink: DisplayLink?
    private let automaticallyAdvanceTime: Bool
    
    // MARK: - Deinit
    
    deinit {
        stopLoop()
    }
    
    // MARK: - Manage Loop
    
    private func startLoop() {
        
        if displayLink != nil {
            return
        }
                
        displayLink = DisplayLink(handler: {[unowned self] (dt) in
            self.displayLinkCallback(dt: dt)
        })
    }
    
    private func stopLoop() {
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func displayLinkCallback(dt: Double) {
        
        // Update Animations
        step(dt: dt)
    }
    
    /// Advance the scheduler's time by amount dt
    public func step(dt: Double) {
        
        for animation in animations {
            
            // Animations containing finite time actions
            if animation.hasDuration {
                
                var remove = false
                if animation.elapsedTime + dt > animation.duration {
                    remove = true
                }
                
                let newTime = (animation.elapsedTime + dt).constrained(max: animation.duration)
                animation.update(elapsedTime: newTime)
                
                if remove {
                    animationsToRemove.append(animation)
                }
            }
                
                // Animations containing infinite time actions
            else{
                
                let newTime = animation.elapsedTime + dt
                animation.update(elapsedTime: newTime)
            }
            
        }
        
        // Remove finished animations
        animationsToRemove.forEach{
            remove(animation: $0)
        }
        animationsToRemove.removeAll()

    }
}

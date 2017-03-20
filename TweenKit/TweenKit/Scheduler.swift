//
//  Scheduler.swift
//  TweenKit
//
//  Created by Steve Barnegren on 18/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

@objc class Scheduler : NSObject {
    
    // MARK: - Internal
    
    static let shared = Scheduler()
    
    func add(animation: Animation) {
        animations.append(animation)
        animation.willStart()
        startLoop()
    }
    
    func remove(animation: Animation) {
        
        guard let index = animations.index(of: animation) else {
            print("Can't find animation to remove")
            return
        }
        
        animation.didFinish()
        animations.remove(at: index)
        
        if animations.isEmpty {
            stopLoop()
        }
    }
    
    var numRunningAnimations: Int {
        return self.animations.count
    }

    // MARK: - Properties
    
    private var animations = [Animation]()
    private var animationsToRemove = [Animation]()

    private var displayLink: CADisplayLink?
    private var lastTimeStamp: CFTimeInterval?
    
    // MARK: - Manage Loop
    
    private func startLoop() {
        
        if displayLink != nil {
            return
        }
        
        displayLink = CADisplayLink(target: self,
                                    selector: #selector(displayLinkCallback))
        
        displayLink?.add(to: .current,
                         forMode: .defaultRunLoopMode)
    }
    
    private func stopLoop() {
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func displayLinkCallback(displaylink: CADisplayLink) {
        //print(displaylink.timestamp)
        
        // We need a previous time stamp to check against. Save if we don't already have one
        guard let last = lastTimeStamp else{
            lastTimeStamp = displaylink.timestamp
            return
        }
        
        // Update Animations
        let dt = displaylink.timestamp - last
        step(dt: dt)
        
        // Save the current time
        lastTimeStamp = displaylink.timestamp
    }
    
    func step(dt: Double) {
        
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

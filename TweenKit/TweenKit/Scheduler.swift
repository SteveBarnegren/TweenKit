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
        startLoop()
    }
    
    func remove(animation: Animation) {
        
        guard let index = animations.index(of: animation) else {
            print("Can't find animation to remove")
            return
        }
        
        animations.remove(at: index)
        
        if animations.isEmpty {
            stopLoop()
        }
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
                                    selector: #selector(step))
        
        displayLink?.add(to: .current,
                         forMode: .defaultRunLoopMode)
    }
    
    private func stopLoop() {
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func step(displaylink: CADisplayLink) {
        print(displaylink.timestamp)
        
        // We need a previous time stamp to check against. Save if we don't already have one
        guard let last = lastTimeStamp else{
            lastTimeStamp = displaylink.timestamp
            return
        }
        
        
        // Update Animations
        let dt = displaylink.timestamp - last

        for animation in animations {
            
            var remove = false
            if animation.elapsedTime + dt > animation.duration {
                remove = true
            }
            
            animation.elapsedTime = (animation.elapsedTime + dt).constrained(max: animation.duration)
            animation.update(t: animation.elapsedTime / animation.duration)
            
            if remove {
                animationsToRemove.append(animation)
            }
        }
        
        // Remove finished animations
        animationsToRemove.forEach{
            remove(animation: $0)
        }
        animationsToRemove.removeAll()
        
        // Save the current time
        lastTimeStamp = displaylink.timestamp
    }

}

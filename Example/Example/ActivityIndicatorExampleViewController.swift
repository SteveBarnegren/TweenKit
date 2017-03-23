//
//  ActivityIndicatorExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

extension CALayer {
    var center: CGPoint {
        get{
            return CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
        }
        set{
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            frame.origin = CGPoint(x: newValue.x - frame.size.width/2, y: newValue.y - frame.size.height/2)
            CATransaction.commit()
        }
    }
}

class ActivityIndicatorExampleViewController: UIViewController {
    
    let scheduler = Scheduler()

    var circleLayers = [CALayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the circle layers
        let numCircles = 4
        
        for i in 0..<numCircles {
         
            let layer = CALayer()
            
            let alpha = CGFloat(i+1) / CGFloat(numCircles)
            layer.backgroundColor = UIColor.red.withAlphaComponent(alpha).cgColor
            layer.frame.size = CGSize(width: 10, height: 10)
            layer.cornerRadius = layer.bounds.size.width/2
            view.layer.addSublayer(layer)
            self.circleLayers.append(layer)
        }
        circleLayers = circleLayers.reversed()
        
        startAnimation()
    }
    
    func startAnimation() {
        
        // Set layers start positions
        let radius = 50.0
        circleLayers.forEach{
            $0.center = CGPoint(x: self.view.center.x,
                                y: self.view.center.y - CGFloat(radius))
        }
        
        // Create an ArcAction for each layer
        let actions = circleLayers.map{
            layer -> ArcAction<CGPoint> in
            
            let action = ArcAction(center: self.view.center,
                                   radius: radius,
                                   startDegrees: 0,
                                   endDegrees: 360,
                                   duration: 1.3,
                                   update: { [unowned layer] in layer.center = $0 })
            action.easing = .sineInOut
            return action
        }
        
        // Run the actions in a staggered group
        let group = Group(staggered: actions, offset: 0.125)
        
        // Repeat forever
        let repeatForever = group.repeatedForever()
        
        // Run the action
        let animation = Animation(action: repeatForever)
        scheduler.add(animation: animation)
    }
    
}

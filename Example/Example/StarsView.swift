//
//  StarsView.swift
//  Example
//
//  Created by Steven Barnegren on 31/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class StarsView: UIView {
    
    // MARK: - Types
    struct Star {
        var t = 0.0
        let restPosition: CGPoint
        let moveAmount = CGFloat(1.0)
        var startPosition: CGPoint {
            return CGPoint(x: restPosition.x,
                           y: restPosition.y + 80)
        }
        var currentPosition: CGPoint{
            return startPosition.lerp(t: t, end: restPosition)
        }
        
        var color: UIColor {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(t * 0.4))
        }
        
        init(restPosition: CGPoint) {
            self.restPosition = restPosition
        }
    }
    
    // MARK: - Internal
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = UIColor.clear
     
        // Create the stars
        stars = makeStars().sorted{ $0.0.currentPosition.y < $0.1.currentPosition.y }
        
        // Create the action
        let duration = 0.6
        var actions = [InterpolationAction<Double>]()
        
        for index in (0..<stars.count) {
            
            let action = InterpolationAction(from: 0.0,
                                             to: 1.0,
                                             duration: duration,
                                             easing: .sineOut) {
                                                [unowned self] in
                                                self.stars[index].t = $0
            }
            actions.append(action)
        }
        
        let group = Group(staggered: actions, offset: (1.0 - duration) / Double(actions.count))
        self.actionScrubber = ActionScrubber(action: group)
    }
    
    func update(t: Double) {
        actionScrubber.update(t: t)
        setNeedsDisplay()
    }
    
    // MARK: - Properties
    
    var stars: [Star]!
    var actionScrubber: ActionScrubber!
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.clear(rect)
        
        stars.forEach{
            
            $0.color.set()
            
            let radius = CGFloat(3.0)
            let rect = CGRect(x: $0.currentPosition.x - radius,
                              y: $0.currentPosition.y - radius,
                              width: radius*2,
                              height: radius*2)
            
            UIBezierPath(ovalIn: rect).fill()
        }
    }
    
    // MARK: - Methods
    
    func makeStars() -> [Star] {
        
        var stars = [Star]()
        let numStars = 1000
        
        (0..<numStars).forEach{ _ in
            
            let x = arc4random() % UInt32(bounds.size.width)
            let y = arc4random() % UInt32(bounds.size.height)
            let position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            
            for existingStar in stars {
                
                if position.distanceTo(other: existingStar.restPosition) < 100 {
                    return
                }
            }
        
            let star = Star(restPosition: position)
            stars.append(star)
        }
        return stars
    }
    
    
    
}

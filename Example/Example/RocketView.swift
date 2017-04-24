//
//  RocketView.swift
//  Example
//
//  Created by Steven Barnegren on 31/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class RocketView: UIView {
    
    // MARK: - Internal
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        isUserInteractionEnabled = false
        
        // Set draw closure
        drawPathView.drawClosure = {
            [unowned self] in
            
            UIColor.white.set()
            self.path.stroke()
            
            UIColor.clear.set()
            let rightRect = CGRect(x: self.rocketImageView.center.x,
                                   y: 0,
                                   width: self.bounds.size.width - self.rocketImageView.center.x,
                                   height: self.bounds.size.height)
            UIRectFill(rightRect)
        }
        
        // Add subviews
        addSubview(drawPathView)
        addSubview(rocketImageView)
        
        // Create the action
        let action = BezierAction(path: path.asBezierPath(),
                                  duration: 1.0) {
                                    [unowned self] (position, rotation) in
                                    self.rocketImageView.center = position
                                    
                                    let rocketRotation = CGFloat(rotation.value)
                                    self.rocketImageView.transform = CGAffineTransform(rotationAngle: rocketRotation)
                                    
                                    self.drawPathView.redraw()
        }
        
        actionScrubber = ActionScrubber(action: action)
        
        // Set the initial state
        setRocketAnimationPct(t: 0.0)
    }
    
    func setRocketAnimationPct(t: Double) {
        
        guard let scrubber = actionScrubber else {
            return
        }
        
        // Fade out the trail at the end
        let trailFadeTime = 0.5
        if t < 1 - trailFadeTime {
            drawPathView.alpha = 1.0
        }
        else{
            drawPathView.alpha = CGFloat( 1.0 - (t-(1-trailFadeTime)) * (1/trailFadeTime) )
        }
        
        // Animate the rocket
        // We need to extend t < 0 and > 1 so that the rocket starts and finishes offscreen
        // Because TweenKit supports overshooting bezier curves, this is easy to do
        let additional = 0.1
        let minT = t - additional
        let maxT = t + additional
        let newT = minT + ((maxT - minT) * t)
        
        scrubber.update(t: newT)
    }
    
    // MARK: - Properties
    
    private var actionScrubber: ActionScrubber?
    
    private let drawPathView: DrawClosureView = {
        let view = DrawClosureView()
        return view
    }()
    
    private let rocketImageView: UIImageView = {
        let image = UIImage(named: "Rocket")!
        let imageView = UIImageView(image: image)
        let scale = CGFloat(0.2)
        imageView.frame.size = CGSize(width: image.size.width * scale,
                                      height: image.size.height * scale)
        return imageView
    }()
    
    private var path: UIBezierPath {
        
        let controlPointsYOffset = bounds.width * 0.4
        let endPointsYOffset = bounds.size.width * 0.2
        
        let start = CGPoint(x: 0,
                            y: bounds.size.height/2 + endPointsYOffset)
        let control1 = CGPoint(x: bounds.size.width/3,
                               y: bounds.size.height/2 + controlPointsYOffset)
        let control2 = CGPoint(x: bounds.size.width/3*2,
                               y: bounds.size.height/2 - controlPointsYOffset)
        let end = CGPoint(x: bounds.size.width,
                          y: bounds.size.height/2 - endPointsYOffset - bounds.size.width*0.1)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: control1, controlPoint2: control2)
        return path
    }
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawPathView.frame = bounds
    }

    
}

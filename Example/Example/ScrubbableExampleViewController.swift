//
//  ScrubbableExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

class ScrubbableExampleViewController: UIViewController {
    
    // MARK: - Constants
    
    
    // MARK: - Properties
    
    let scheduler = Scheduler()
    
    // MARK: - Layers
    
    let sunMiddle: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.orange.cgColor
        return layer
    }()
    
    let sunSideSpoke: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.yellow.cgColor
        return layer
    }()
    
    let sunDiagonalSpoke: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.yellow.cgColor
        return layer
    }()
    
    let moon: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let topPoint = CGPoint(x: layer.bounds.size.width/2,
                               y: 0)
        let bottomPoint = CGPoint(x: layer.bounds.size.width/2,
                                  y: layer.bounds.size.height)
        let bottomLeft = CGPoint(x: 0,
                                 y: layer.bounds.size.height)
        let topLeft = CGPoint.zero
        let middle = CGPoint(x: layer.bounds.size.width/2,
                             y: layer.bounds.size.height/2)
        let innerCurvePct = 0.7
        
        let path = UIBezierPath()
        
        let controlPointXOffset = CGFloat(20)
        let controlPointYOffset = CGFloat(50)
       
        // outer curve to bottom
        path.move(to: topPoint)
        path.addArc(withCenter: middle,
                    radius: layer.bounds.size.width/2,
                    startAngle: CGFloat(-90.degreesToRadians),
                    endAngle: CGFloat(90.degreesToRadians),
                    clockwise: false)
        
        // inner curve to top
        path.addCurve(to: topPoint,
                      controlPoint1: bottomLeft,
                      controlPoint2: topLeft)
 
        path.close()
        layer.path = path.cgPath
        
        return layer
    }()

    // MARK: - Variables
    
    var sunRadius = CGFloat(50) {
        didSet { updateSun() }
    }
    
    var sunRotation = CGFloat(0) {
        didSet{ updateSun() }
    }
    
    var sunSideSpokeSize = CGFloat(1) {
        didSet{ updateSun() }
    }
    
    var sunOnScreenAmount = CGFloat(0.0) {
        didSet{ updateSun() }
    }
    
    var sunPosition: CGPoint {
        
        let maxValue = view.center
        let minValue = CGPoint(x: view.center.x,
                               y: view.bounds.size.height + sunRadius + 50)
        
        return minValue.lerp(t: Double(sunOnScreenAmount), end: maxValue)
    }
    
    var moonOnScreenAmount = CGFloat(0.0) {
        didSet{ updateMoon() }
    }
    
    var moonPosition: CGPoint {
        
        let maxValue = view.center
        let minValue = CGPoint(x: view.center.x,
                               y: view.bounds.size.height + moon.bounds.size.height)
        
        return minValue.lerp(t: Double(moonOnScreenAmount), end: maxValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add sub layers
        view.layer.addSublayer(sunSideSpoke)
        view.layer.addSublayer(sunDiagonalSpoke)
        view.layer.addSublayer(sunMiddle)
        view.layer.addSublayer(moon)
        
        // Start the animation
        let moonAppear = makeMoonAction().reversed()
        let sunAppear = makeSunAction()
        
        let sequence = Sequence(actions: moonAppear, sunAppear)
        let repeated = sequence.yoyo().repeatedForever()
        
        let animation = Animation(action: repeated)
        scheduler.add(animation: animation)
    }
    
    func makeSunAction() -> FiniteTimeAction {
        
        // Animate the sun on screen
        let moveSunOnScreen = InterpolationAction(from: CGFloat(0.0),
                                                  to: CGFloat(1.0),
                                                  duration: 2,
                                                  update: { [unowned self] in self.sunOnScreenAmount = $0; self.sunSideSpokeSize = $0 })
        moveSunOnScreen.easing = .exponentialOut
        
        // Rotate sun
        let rotateSun = InterpolationAction(from: 0.0,
                                            to: 360.0 * 3.0,
                                            duration: 2.5,
                                            update: { [unowned self] in self.sunRotation = $0})
        rotateSun.easing = .exponentialOut
        
        
        // Create group
        let group = Group(actions: moveSunOnScreen, rotateSun)
        
        return group
       
    }
    
    func makeMoonAction() -> FiniteTimeAction {
        
        // animate the moon on screen
        let action = InterpolationAction(from: 0.0,
                                         to: 1.0,
                                         duration: 2,
                                         update: { [unowned self] in self.moonOnScreenAmount = $0 })
        action.easing = .exponentialOut
        return action
    }
    
    // MARK: - Update
    
    func updateSun() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateSunMiddle()
        updateSunSideSpoke()
        updateSunDiagonalSpoke()
        
        CATransaction.commit()
    }
    
    func updateSunMiddle() {
        
        sunMiddle.frame = CGRect(x: sunPosition.x - sunRadius,
                                 y: sunPosition.y - sunRadius,
                                 width: sunRadius * 2,
                                 height: sunRadius * 2)
        
        sunMiddle.cornerRadius = sunMiddle.bounds.size.width/2
    }
    
    func updateSunSideSpoke() {
        
        sunSideSpoke.transform = CATransform3DIdentity
        
        let sideLength = sunRadius * 2 * sunSideSpokeSize
        sunSideSpoke.frame = CGRect(x: sunPosition.x - sideLength/2,
                                    y: sunPosition.y - sideLength/2,
                                    width: sideLength,
                                    height: sideLength)
        
        let newTransform = CATransform3DMakeRotation(CGFloat(sunRotation.degreesToRadians), 0, 0, 1)
        sunSideSpoke.transform = newTransform
        
    }
    
    func updateSunDiagonalSpoke() {
        
        sunDiagonalSpoke.transform = CATransform3DIdentity
        
        let sideLength = sunRadius * 2 * sunSideSpokeSize
        sunDiagonalSpoke.frame = CGRect(x: sunPosition.x - sideLength/2,
                                        y: sunPosition.y - sideLength/2,
                                        width: sideLength,
                                        height: sideLength)
        
        let newTransform = CATransform3DMakeRotation(CGFloat((45 + sunRotation).degreesToRadians), 0, 0, 1)
        sunDiagonalSpoke.transform = newTransform
        
    }
    
    func updateMoon() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        moon.frame = CGRect(x: moonPosition.x - moon.bounds.size.width/2,
                            y: moonPosition.y - moon.bounds.size.height/2,
                            width: moon.bounds.size.width,
                            height: moon.bounds.size.height)
        
        CATransaction.commit()
    }


}

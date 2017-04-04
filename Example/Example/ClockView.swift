//
//  ClockView.swift
//  Example
//
//  Created by Steven Barnegren on 04/04/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    // MARK: - Public
    
    var hours = 15.0 {
        didSet{ drawView.redraw() }
    }
    
    var onScreenAmount = 1.0 {
        didSet{ drawView.redraw() }
    }
    
    var size = 1.0 {
        didSet{ drawView.redraw() }
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        drawView.drawClosure = {
            
            func drawHandWithHours(hours: Double, length: Double) {
                
                let angle = ((Double.pi * 2) * hours/12.0) - Double.pi/2
                let x = cos(angle) * length
                let y = sin(angle) * length
                
                let start = self.clockPosition
                let end = CGPoint(x: self.clockPosition.x + CGFloat(x),
                                  y: self.clockPosition.y + CGFloat(y))
                
                let path = UIBezierPath()
                path.move(to: start)
                path.addLine(to: end)
                path.lineWidth = self.lineWidth
                path.stroke()
            }
            
            UIColor.white.set()
            
            let clockBounds = CGRect(x: self.clockPosition.x - (self.clockSize.width/2),
                                     y: self.clockPosition.y - (self.clockSize.height/2),
                                     width: self.clockSize.width,
                                     height: self.clockSize.height)
            let path = UIBezierPath(ovalIn: clockBounds)
            path.lineWidth = self.lineWidth
            path.stroke()
            
            let hourHandHours = self.hours
            let minuteHandHours = self.hours * 12
            
            drawHandWithHours(hours: hourHandHours, length: Double(self.clockSize.height/2) * 0.333)
            drawHandWithHours(hours: minuteHandHours, length: Double(self.clockSize.height/2) * 0.666)
        }
        
        addSubview(drawView)
    }
    
    // MARK: - Properties
    
    let lineWidth = CGFloat(3)
    
    var clockPosition: CGPoint {
        
        let min = CGPoint(x: UIScreen.main.bounds.size.width/2,
                          y: UIScreen.main.bounds.size.height + (clockSize.height/2) + 10)
        let max = CGPoint(x: UIScreen.main.bounds.size.width/2,
                          y: UIScreen.main.bounds.size.height/2)
        return min.lerp(t: onScreenAmount, end: max)
    }
    
    var clockSize: CGSize {
        let sideLength = 120.0 * self.size
        return CGSize(width: sideLength,
                      height: sideLength)
    }
    
    let drawView: DrawClosureView = {
        let view = DrawClosureView()
        return view
    }()
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawView.frame = bounds
    }
    
    // MARK: - Methods
    
    
    
    
    
    
    
    
}

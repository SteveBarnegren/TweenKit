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
    
    var fillOpacity = CGFloat(0) {
        didSet{ drawView.redraw() }
    }
    
    var clockRect: CGRect {
        return CGRect(x: clockPosition.x - clockSize.width/2,
                      y: clockPosition.y - clockSize.height/2,
                      width: clockSize.width,
                      height: clockSize.height)
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        drawView.drawClosure = {
            
            func handEndPoint(hours: Double, length: Double) -> CGPoint {
                
                let angle = ((Double.pi * 2) * hours/12.0) - Double.pi/2
                let x = cos(angle) * length
                let y = sin(angle) * length
                
                return CGPoint(x: self.clockPosition.x + CGFloat(x),
                               y: self.clockPosition.y + CGFloat(y))
            }
            
            UIColor.white.set()
            
            let clockBounds = CGRect(x: self.clockPosition.x - (self.clockSize.width/2),
                                     y: self.clockPosition.y - (self.clockSize.height/2),
                                     width: self.clockSize.width,
                                     height: self.clockSize.height)
            let borderPath = UIBezierPath(ovalIn: clockBounds)
            borderPath.lineWidth = self.lineWidth
            borderPath.stroke()
            
            let hourHandEnd = handEndPoint(hours: self.hours, length: Double(self.clockSize.height/2) * 0.333)
            let minuteHandEnd = handEndPoint(hours: self.hours * 12, length: Double(self.clockSize.height/2) * 0.666)
            
            let handsPath = UIBezierPath()
            handsPath.move(to: hourHandEnd)
            handsPath.addLine(to: self.clockPosition)
            handsPath.addLine(to: minuteHandEnd)
            
            handsPath.lineWidth = self.lineWidth
            handsPath.lineJoinStyle = .round
            handsPath.lineCapStyle = .round
            handsPath.stroke()
            
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: self.fillOpacity).set()
            borderPath.fill()

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

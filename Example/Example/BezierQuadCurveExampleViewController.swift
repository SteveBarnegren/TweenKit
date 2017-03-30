//
//  BezierQuadCurveExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 29/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class BezierQuadCurveExampleViewController: UIViewController {
    
    let scheduler = Scheduler()
    var isAnimating = false
    var curvePoints = [CGPoint.zero, CGPoint.zero, CGPoint.zero]
    
    var startPoint: CGPoint {
        get{ return curvePoints[0] }
        set{ curvePoints[0] = newValue }
    }
    
    var controlPoint: CGPoint {
        get{ return curvePoints[1] }
        set{ curvePoints[1] = newValue }
    }
    
    var endPoint: CGPoint {
        get{ return curvePoints[2] }
        set{ curvePoints[2] = newValue }
    }
    
    var path: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        return path
    }
    
    let pointsView: DraggablePointsView = {
        let view = DraggablePointsView(frame: .zero)
        return view
    }()
    
    let drawView: DrawClosureView = {
        let view = DrawClosureView()
        return view
    }()
    
    let animatingLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame.size = CGSize(width: 40, height: 40)
        return layer
    }()
    
    let easingSelector: CycleSelector<Easing> =  {
        
        let options: [(String, Easing)] = [
            ("Linear", .linear),
            ("ExponentialInOut", .exponentialInOut),
            ("ElasticIn", .elasticIn),
            ("ElasticOut", .elasticOut),
            ]
        
        let selector = CycleSelector(options: options)
        return selector
    }()
    
    let durationSelector: CycleSelector<Double> =  {
        
        let options: [(String, Double)] = [
            ("1s", 1.0),
            ("2s", 2.0),
            ("3s", 3.0),
            ("4s", 4.0),
            ]
        
        let selector = CycleSelector(options: options)
        return selector
    }()

    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculate points start
        let sideMargin = CGFloat(70.0)
        startPoint = CGPoint(x: sideMargin,
                             y: UIScreen.main.bounds.size.height/2)
        controlPoint = CGPoint(x: UIScreen.main.bounds.size.width/2,
                               y: UIScreen.main.bounds.size.height/2 - 100)
        endPoint = CGPoint(x: UIScreen.main.bounds.size.width - sideMargin,
                           y: UIScreen.main.bounds.size.height/2)
        
        // Background
        view.backgroundColor = UIColor.white
        
        // Draw view
        drawView.drawClosure = {
            [unowned self] in
            UIColor.red.set()
            self.path.stroke()
        }
        view.addSubview(drawView)
        
        // Animating layer
        view.layer.addSublayer(animatingLayer)
        animatingLayer.isHidden = true
        
        // Points view
        view.addSubview(pointsView)
        pointsView.dataSource = self
        pointsView.delegate = self
        pointsView.reload()
        
        // Easing selector
        view.addSubview(easingSelector)
        easingSelector.onSelect = {
            [unowned self] _ in
            self.stopAnimation()
            self.startAnimation()
        }
        
        // Duration Selector
        view.addSubview(durationSelector)
        durationSelector.onSelect = {
            [unowned self] _ in
            self.stopAnimation()
            self.startAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pointsView.frame = view.bounds
        drawView.frame = view.bounds
        
        easingSelector.sizeToFit()
        easingSelector.frame.origin = CGPoint(x: view.bounds.size.width - easingSelector.bounds.size.width - 8,
                                              y: 8)
        
        durationSelector.sizeToFit()
        durationSelector.frame.origin = CGPoint(x: 8, y: 8)
    }
    
    // MARK: - Methods
    
    fileprivate func startAnimation() {
        
        if isAnimating {
            return
        }
        
        animatingLayer.center = startPoint
        animatingLayer.isHidden = false
        
        let bezierPath = path.asBezierPath()
        let action = BezierAction(path: bezierPath, duration: durationSelector.selectedValue) {
            [unowned self] in
            self.animatingLayer.center = $0
        }
        action.easing = easingSelector.selectedValue
        scheduler.run(action: action)
        
        isAnimating = true
    }
    
    fileprivate func stopAnimation() {
        
        if !isAnimating {
            return;
        }
        
        scheduler.removeAll()
        animatingLayer.isHidden = true
        
        isAnimating = false
    }
    
}

extension BezierQuadCurveExampleViewController: DraggablePointsViewDataSource {
    
    func numberOfPoints(forDraggablePointsView: DraggablePointsView) -> Int {
        return curvePoints.count
    }
    
    func colorForPoint(atIndex: Int) -> UIColor {
        return UIColor.orange
    }
    
    func locationForPoint(atIndex index: Int) -> CGPoint {
        return curvePoints[index]
    }
}

extension BezierQuadCurveExampleViewController: DraggablePointsViewDelegate {
    
    func draggablePointsViewWillBeginDragging() {
        stopAnimation()
    }
    
    func draggablePointsViewDidEndDragging() {
        startAnimation()
    }

    
    func draggablePointsViewDraggedPoint(atIndex index: Int, to newLocation: CGPoint) {
        curvePoints[index] = newLocation
        drawView.redraw()
    }
}

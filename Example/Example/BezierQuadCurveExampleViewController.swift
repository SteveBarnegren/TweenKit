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
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startPoint = CGPoint(x: 50, y: 50)
        controlPoint = CGPoint(x: 100, y: 100)
        endPoint = CGPoint(x: 200, y: 200)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pointsView.frame = view.bounds
        drawView.frame = view.bounds
    }
    
    // MARK: - Methods
    
    fileprivate func startAnimation() {
        
        if isAnimating {
            return
        }
        
        animatingLayer.center = startPoint
        animatingLayer.isHidden = false
        
        let bezierPath = path.asBezierPath()
        let action = BezierAction(path: bezierPath, duration: 1) {
            [unowned self] in
            self.animatingLayer.center = $0
        }
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

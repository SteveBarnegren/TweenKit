//
//  BezierCurveExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 29/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class BezierCurveExampleViewController: UIViewController {
    
    // MARK: - Public
    
    init(model: BezierDemoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Properties
    
    let scheduler = Scheduler()
    var isAnimating = false
    let model: BezierDemoModel!
    
    var points = [CGPoint]()

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
        
        let options = Easing.all().map{
            ($0.name, $0)
        }
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create points
        (0..<model.numberOfPoints).forEach{
            let point = model.startPositionForPoint(atIndex: $0)
            self.points.append(point)
        }
        
        // Background
        view.backgroundColor = UIColor.white
        
        // Draw view
        drawView.drawClosure = {
            [unowned self] in
            
            UIColor.orange.set()
            for (from, to) in self.model.connections {
                let path = UIBezierPath()
                path.move(to: self.points[from])
                path.addLine(to: self.points[to])
                path.stroke()
            }
            
            UIColor.red.set()
            self.model.makePath(fromPoints: self.points).stroke()
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
        
        // Reset the layer position and roation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.animatingLayer.transform = CATransform3DIdentity
        self.animatingLayer.frame.origin = CGPoint(x: points.first!.x - self.animatingLayer.frame.size.width/2,
                                                   y: points.first!.y - self.animatingLayer.frame.size.height/2)
        CATransaction.commit()

        animatingLayer.isHidden = false
        
        // Create the action
        let bezierPath = model.makePath(fromPoints: self.points).asBezierPath()
        
        let action = BezierAction(path: bezierPath, duration: durationSelector.selectedValue) {
            [unowned self] (position, rotation) in
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            self.animatingLayer.transform = CATransform3DIdentity
            self.animatingLayer.frame.origin = CGPoint(x: position.x - self.animatingLayer.frame.size.width/2,
                                                       y: position.y - self.animatingLayer.frame.size.height/2)
            self.animatingLayer.transform = CATransform3DMakeRotation(CGFloat(rotation.value), 0, 0, 1)
            CATransaction.commit()
            
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

extension BezierCurveExampleViewController: DraggablePointsViewDataSource {
    
    func numberOfPoints(forDraggablePointsView: DraggablePointsView) -> Int {
        return model.numberOfPoints
    }
    
    func colorForPoint(atIndex: Int) -> UIColor {
        return UIColor.orange
    }
    
    func locationForPoint(atIndex index: Int) -> CGPoint {
        return points[index]
    }
}

extension BezierCurveExampleViewController: DraggablePointsViewDelegate {
    
    func draggablePointsViewWillBeginDragging() {
        stopAnimation()
    }
    
    func draggablePointsViewDidEndDragging() {
        startAnimation()
    }

    
    func draggablePointsViewDraggedPoint(atIndex index: Int, to newLocation: CGPoint) {
        points[index] = newLocation
        drawView.redraw()
    }
}

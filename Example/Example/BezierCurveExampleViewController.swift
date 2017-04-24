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
    
    // MARK: - Internal
    
    init(model: BezierDemoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Properties
    
    fileprivate let scheduler = ActionScheduler()
    fileprivate var isAnimating = false
    fileprivate let model: BezierDemoModel!
    
    fileprivate var points = [CGPoint]()

    fileprivate let pointsView: DraggablePointsView = {
        let view = DraggablePointsView(frame: .zero)
        return view
    }()
    
    fileprivate let drawView: DrawClosureView = {
        let view = DrawClosureView()
        return view
    }()
    
    fileprivate let animatingLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame.size = CGSize(width: 40, height: 40)
        return layer
    }()
    
    fileprivate let easingSelector: CycleSelector<Easing> =  {
        
        let options = Easing.all().map{
            ($0.name, $0)
        }
        
        let selector = CycleSelector(options: options)
        return selector
    }()
    
    fileprivate let durationSelector: CycleSelector<Double> =  {
        
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
        showInstructionPrompt()
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
    
    fileprivate func showInstructionPrompt() {
        
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drag the points to change the curve"
        label.textColor = UIColor.darkText
        label.alpha = 0
        view.addSubview(label)
        
        let leftPin = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: label, attribute: .left, multiplier: 1, constant: -8)
        let rightPin = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: 8)
        let bottomPin = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 60)
        view.addConstraints([leftPin, rightPin, bottomPin])
        
        // Fade in then out
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            [weak label] in
            label?.alpha = 1
            
            }, completion: { _ in
                
                UIView.animate(withDuration: 0.6, delay: 3, options: .curveEaseInOut, animations: {
                    [weak label] in
                    label?.alpha = 0
                    }, completion: {
                        [weak label] _ in
                        label?.removeFromSuperview()
                })
                
        })
        
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

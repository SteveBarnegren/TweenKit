//
//  DraggablePointsView.swift
//  Example
//
//  Created by Steven Barnegren on 29/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

protocol DraggablePointsViewDataSource {
    
    func numberOfPoints(forDraggablePointsView: DraggablePointsView) -> Int
    func locationForPoint(atIndex: Int) -> CGPoint
    func colorForPoint(atIndex: Int) -> UIColor
}

protocol DraggablePointsViewDelegate {
    func draggablePointsViewWillBeginDragging()
    func draggablePointsViewDraggedPoint(atIndex index: Int, to newLocation: CGPoint)
    func draggablePointsViewDidEndDragging()
}

class DraggablePointsView: UIView {
    
    // MARK: - Types

    struct Point {
        var color: UIColor
        var location: CGPoint
        
        init(location: CGPoint, color: UIColor){
            self.location = location
            self.color = color
        }
    }
    
    enum State {
        case idle
        case dragging(index: Int, touchOffset: CGPoint)
    }
    
    // MARK: - Public
    
    var dataSource: DraggablePointsViewDataSource?
    var delegate: DraggablePointsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    func reload() {
        updateFromDataSource()
    }
    
    // MARK: - Properties
    
    var points = [Point]()
    var state = State.idle
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //UIColor.black.set()
        //let fullRectPath = UIBezierPath(rect: rect)
        //fullRectPath.fill()
        
        let radius = CGFloat(5.0)
        
        for point in points {
            
            point.color.set()
            
            let rect = CGRect(x: point.location.x - radius,
                              y: point.location.y - radius,
                              width: radius * 2,
                              height: radius * 2)
            
            let path = UIBezierPath(ovalIn: rect)
            path.fill()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate?.draggablePointsViewWillBeginDragging()
        
        let location = touches.first!.location(in: self)
        
        guard let index = pointIndexForTouchLocation(location) else {
            return;
        }
        
        let point = points[index]
        let touchOffset = CGPoint(x: location.x - point.location.x,
                                  y: location.y - point.location.y)
        
        state = .dragging(index: index,
                          touchOffset: touchOffset)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        
        guard case let State.dragging(index, touchOffset) = state else {
            return
        }
        
        points[index].location = CGPoint(x: location.x + touchOffset.x,
                                         y: location.y + touchOffset.y)
        
        delegate?.draggablePointsViewDraggedPoint(atIndex: index,
                                                  to: points[index].location)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .idle
        delegate?.draggablePointsViewDidEndDragging()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .idle
        delegate?.draggablePointsViewDidEndDragging()
    }
    
    // MARK: - Methods
    
    private func pointIndexForTouchLocation(_ location: CGPoint) -> Int? {
        
        let selectDistance = 20.0
        
        var closestIndex: Int?
        
        for (index, point) in points.enumerated() {

            guard location.distanceTo(other: point.location) < selectDistance else {
                continue
            }
            
            let closestPoint: Point? = closestIndex == nil ? nil : points[closestIndex!]
            
            if let closest = closestPoint, location.distanceTo(other: point.location) < location.distanceTo(other: closest.location){
                closestIndex = index
            }
            else{
                closestIndex = index
            }
        }
        
        return closestIndex
    }
    
    private func updateFromDataSource() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        let numPoints = dataSource.numberOfPoints(forDraggablePointsView: self)
        
        points.removeAll()
        
        (0..<numPoints).forEach{
            let color = dataSource.colorForPoint(atIndex: $0)
            let location = dataSource.locationForPoint(atIndex: $0)
            let point = Point(location: location, color: color)
            points.append(point)
        }
        
        setNeedsDisplay()
    }
    
    
}

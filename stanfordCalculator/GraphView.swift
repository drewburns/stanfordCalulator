//
//  GraphView.swift
//  stanfordCalculator
//
//  Created by Andrew Burns on 11/13/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func getPoints(sender: GraphView) -> [CGPoint]
}

@IBDesignable

class GraphView: UIView {

    var origin: CGPoint = CGPoint()
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    var lineWidth: CGFloat = 3
    
    var increment: CGFloat = 0.5
    var range_min_x: CGFloat = -100
    var range_max_x: CGFloat = 100
    
    var scale: CGFloat = 50 {
        didSet {
            updateRange()
            setNeedsDisplay()
        }
    }
    
    var axesOrigin = CGPoint(x: 0, y: 0) {
        didSet {
            updateRange()
            setNeedsDisplay()
        }
    }
    
    func updateRange() {
        range_min_x = -axesOrigin.x / scale

        
        range_max_x =  range_min_x + (bounds.size.width / scale)
        
        increment = (1.0/scale)
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            center.x += (translation.x / 2)
            center.y += (translation.y / 2)
            gesture.setTranslation(CGPointZero, inView: self)
            updateRange()
            setNeedsDisplay()
        default: break
        }
    }
    
    weak var dataSource: GraphViewDataSource?
    
    override func drawRect(rect: CGRect) {
        origin = center
        AxesDrawer(contentScaleFactor: contentScaleFactor)
            .drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        color.set()
        var points = dataSource?.getPoints(self)
        if points!.count != 0 {
            let firstpoint = points!.removeFirst()
            path.moveToPoint(firstpoint)
            for point in points! {
                path.addLineToPoint(point)
            }
            path.stroke()
        }

    }
}

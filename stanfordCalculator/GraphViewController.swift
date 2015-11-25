//
//  GraphViewController.swift
//  stanfordCalculator
//
//  Created by Andrew Burns on 11/13/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController , GraphViewDataSource{
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView , action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView , action:"pan:"))
        }
    }
    
    
    func getPoints(sender: GraphView) -> [CGPoint] {
        var points = [CGPoint]()
        var min_x = sender.range_min_x
        let max_x = sender.range_max_x
        while min_x <= max_x {
            if let y = brain.y(Double(min_x)) {
                let xValue = sender.center.x + (min_x * sender.scale)
                let yValue = sender.center.y - (CGFloat(y) * sender.scale)
                points.append(CGPoint(x: xValue , y: yValue))
            }
            min_x += sender.increment
        }
        while min_x >= -max_x {
            if let y = brain.y(Double(min_x)) {
                let xValue = sender.center.x + (min_x * sender.scale)
                let yValue = sender.center.y - (CGFloat(y) * sender.scale)
                points.append(CGPoint(x: xValue , y: yValue))
            }
            min_x -= sender.increment
        }
        return points
    }
    

    
    
    private var brain = CalculatorBrain()
    var program: AnyObject {
        get {
           return brain.program
        }
        set {
           brain.program = newValue
        }
    }
}
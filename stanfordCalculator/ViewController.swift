//
//  ViewController.swift
//  stanfordCalculator
//
//  Created by Andrew Burns on 10/31/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    var userIsTyping = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
        
    }
    

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsTyping {
            enter()
        }
        switch operation {
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": singleperformOperation {sqrt($0)}
        default: break
        }
    }
    func performOperation(operation: (Double, Double) -> Double ){
        if stack.count >= 2 {
            displayValue = operation(stack.removeLast(), stack.removeLast())
            enter()
        }
        
    }
    func singleperformOperation(operation: Double -> Double) {
        
        if stack.count >= 1 {
            displayValue = operation(stack.removeLast())
            enter()
        }
    }


    var stack = Array<Double>()
    @IBAction func enter() {
        userIsTyping = false
        stack.append(displayValue)
        print(stack)
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = "\(newValue)"
            userIsTyping = false
        }
    }

}


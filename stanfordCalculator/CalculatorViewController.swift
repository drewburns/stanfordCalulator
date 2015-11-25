//
//  ViewController.swift
//  stanfordCalculator
//
//  Created by Andrew Burns on 10/31/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var stackDisplay: UILabel!
    var userIsTyping = false
    var hasUsedDecimal = false
    @IBOutlet weak var decimal: UIButton!
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping && hasUsedDecimal == false && digit == "."{
            display.text = display.text! + digit
            hasUsedDecimal = true
            decimal.enabled = false
        } else if userIsTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
        
    }
    


    @IBAction func operate(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                display.text = "nil"
                brain.clearStack()
            }
        }

    }

    @IBAction func clear() {
        brain.clearStack()
        displayValue = 0
        stackDisplay.text = " "
        brain.storeValue("M", value: 0 )

    }

    @IBAction func enter() {
        userIsTyping = false
        hasUsedDecimal = false
        decimal.enabled = true
        if displayValue != nil {
            brain.pushOperand(displayValue!)
            displayValue = NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        } else {
            displayValue = nil
        }
        
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil) {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                display.text = " "
            }
            userIsTyping = false
            stackDisplay.text = brain.runDescription()
        }
    }
    
    
    @IBAction func pushVariable(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func storeVariable(sender: UIButton) {
        if let _ = sender.currentTitle {
            if displayValue != nil {
                brain.storeValue("M", value: displayValue! )
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let graphvc = destination as? GraphViewController {
            graphvc.program = brain.program
            graphvc.title = "y = \(stackDisplay.text!)"
        }
    }

}


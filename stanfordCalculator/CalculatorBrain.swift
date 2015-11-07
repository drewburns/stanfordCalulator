//
//  CalculatorBrain.swift
//  stanfordCalculator
//
//  Created by Andrew Burns on 11/1/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String , Double -> Double)
        case BinaryOperation(String , (Double, Double) -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let symbol , _):
                    return symbol
                case .UnaryOperation(let symbol , _):
                    return symbol
                case .Variable(let variable):
                    return "\(variable)"
                }
            }
            
        }
    
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = [String: Double]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−", {$1 - $0} )
        knownOps["÷"] = Op.BinaryOperation("÷", {$1 / $0} )
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    
    }
    

    private func evaluate(ops: [Op]) -> (result: Double? , remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand) , operandEvaluation.remainingOps)
                }
            case .Variable(let symbol):
                if let variable = variableValues[symbol] {
                    return(variable, remainingOps)
                } else {
                    return(nil, remainingOps)
                }
            
            }
        }
        return (nil, ops)
    }
    
    private func description(ops: [Op]) -> (result: String? , remainingOps: [Op] ) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (String(operand) , remainingOps)
                case .Variable(let symbol):
                    return (symbol , remainingOps)
                case .BinaryOperation(let symbol, _ ):
                    let operandEval1 = description(remainingOps)
                    if var operand1 = operandEval1.result {
                        operand1 = "\(operand1)"

                    let operandEval2 = description(operandEval1.remainingOps)
                    if var operand2 = operandEval2.result {
                        operand2 = "\(operand2)"
                        print("\(operand2) \(symbol) \(operand1)")
                        return ("(\(operand2) \(symbol) \(operand1))",
                            operandEval2.remainingOps)
                    }
                    }
                
                case.UnaryOperation(let symbol, _ ):
                    let operandEvaluation = description(remainingOps)
                    if var operand = operandEvaluation.result {
                        operand = "(\(operand))"
                        print("\(symbol) \(operand)")
                        return ("\(symbol) \(operand)" , remainingOps)
                    }
            }
        }
        return ("?", ops)
    }

    func evaluate() -> Double? {
        let(result, remainder)  = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func pushOperand(symbol: String) -> Double? {

        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    func clearStack() {
        opStack.removeAll()
        variableValues.removeAll()
    }
    func storeValue(symbol: String, value: Double){
        variableValues[symbol] = value
        print(variableValues)
    }
    
    func runDescription() -> String {
        let history = description(opStack)
        return history.result!
    }
    
    
}
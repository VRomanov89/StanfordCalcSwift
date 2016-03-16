//
//  CalculatorBrain.swift
//  StanfordCalcSwift
//
//  Created by Volodymyr Romanov on 3/15/16.
//  Copyright © 2016 Volodymyr Romanov. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    private var opStack = [Op]() // Exactly as Array<Op>()
    
    private var knownOps = [String: Op]() // Exactly as Dictionary<String, Op>()
    
    init() {
        knownOps["*"] = Op.BinaryOperation("*", {$0  * $1})
        knownOps["/"] = Op.BinaryOperation("/", {$1  / $1})
        knownOps["-"] = Op.BinaryOperation("-", {$1  - $0})
        knownOps["+"] = Op.BinaryOperation("+", {$1  + $1})
        knownOps["sqrt"] = Op.UnaryOperation("sqrt", {sqrt($0)})
        
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}
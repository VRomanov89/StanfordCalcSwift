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
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if(!ops.isEmpty) {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            
        }
        return (nil, ops)
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
//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by SofiaBuslavskaya on 28/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1*op2
}

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var operations: Dictionary<String, Operation> = [
        "pi": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation{ -$0 },
        "*": Operation.binaryOperation{ $0 * $1 },
        "/": Operation.binaryOperation{ $0 / $1 },
        "-": Operation.binaryOperation{ $0 - $1 },
        "+": Operation.binaryOperation{ $0 * $1 },
        "=": Operation.equals
    ]
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
        
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let operand = accumulator {
                    accumulator = function(operand)
                }
            case .binaryOperation(let multiply):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: multiply,
                                                 firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}

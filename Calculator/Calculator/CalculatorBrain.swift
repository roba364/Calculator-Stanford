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

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)->Double)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "pi": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation(changeSign(operand:))
    ]
    
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
                
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}

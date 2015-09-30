//
//  ViewController.swift
//  Assignment1_Calculator
//
//  Created by Khoa Bui on 9/28/15.
//  Copyright © 2015 Khoa Bui. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!

    var userIsTyping: Bool = false
    
    var brain = CalculatorBrain()
    
    let π = M_PI
    
    @IBAction func appendDigit(sender: UIButton) {
        if userIsTyping {
            if sender.currentTitle! == "." {
                if display.text!.rangeOfString(".") != nil {
                    return
                }
            }
            
            display.text = display.text! + sender.currentTitle!
        } else {
            display.text = sender.currentTitle!
            userIsTyping = true
        }
        if sender.currentTitle! == "π" {
            display.text = "\(π)"
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        history.text = history.text! + "[" + sender.currentTitle! + "]"
        if userIsTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        display.text = "=" + display.text!
    }

    @IBAction func backspace() {
        if userIsTyping {
            if display.text!.characters.count > 1 {
                display.text = String(display.text!.characters.dropLast())
            } else {
                display.text = "0"
            }
            
            // If you set user is typing to false every time this executes, it'll only let you backspace once. Fix.
            userIsTyping = false
        }
    }

    @IBAction func changeSign() {
        if userIsTyping {
            if display.text!.rangeOfString("-") == nil {
                display.text = "-" + display.text!
            } else {
                display.text = String(display.text!.characters.dropFirst())
            }
        }
        // If the user isn't typing, this should act like a Unary function (such as sin, cos, or square root).
    }
    
    
    @IBAction func enter() {
        history.text = history.text! + "[" + "\(displayValue)" + "]"
        userIsTyping = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
        // newValue is a magical variable that means "whatever the caller is setting displayValue to". Therefore
        // newValue will always be whatever type displayValue is, which in this case is a (Double?). Therefore in
        // line 100, you have to unwrap it. Otherwise, f/e it will show Optional(3) if you set displayValue to 3.
            if newValue != nil {
                display.text = "\(newValue!)"
                userIsTyping = false
            } else {
                display.text = "0"
            }
        }
    }
    
    @IBAction func clear() {
        display.text = "0"
        history.text = "History:"
        brain.performClear()
        userIsTyping = false
    }
    
}


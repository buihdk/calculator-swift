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
            if newValue != nil {
                display.text = "\(newValue)"
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


//
//  StepperView.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 16/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class StepperView: NSView
{
    @IBOutlet var textField: NSTextField!
    @IBOutlet var stepper: NSStepper!

    var integerValue: Int
    {
		get
        {
            return stepper.integerValue
        }

        set(newValue)
        {
			textField.integerValue = newValue
            stepper.integerValue = newValue
        }
    }

    var minimum: Int
    {
        get
        {
            return Int(stepper.minValue)
        }

        set(newValue)
        {
            let numFormatter = textField.formatter as! NSNumberFormatter
            numFormatter.minimum = newValue
            stepper.minValue = Double(newValue)
        }
    }
    var maximum: Int
        {
        get
        {
            return Int(stepper.maxValue)
        }

        set(newValue)
        {
            let numFormatter = textField.formatter as! NSNumberFormatter
            numFormatter.maximum = newValue
            stepper.maxValue = Double(newValue)
        }
    }

    @IBAction func changeValue(sender: AnyObject)
    {
        var newValue: Int?
        if sender === textField
        {
            newValue = textField.integerValue
            stepper.integerValue = newValue!
        }
        else if sender === stepper
        {
            newValue = stepper.integerValue
            textField.integerValue = newValue!
        }
        if let newValue = newValue
        {
            // Send an action message
        }
    }

}

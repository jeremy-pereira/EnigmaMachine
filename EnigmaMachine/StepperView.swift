//
//  StepperView.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 16/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//
/*

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

import Cocoa

class StepperView: NSControl
{
    @IBOutlet var textField: NSTextField!
    @IBOutlet var stepper: NSStepper!

    override var integerValue: Int
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
            let numFormatter = textField.formatter as! NumberFormatter
            numFormatter.minimum = newValue as NSNumber
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
            let numFormatter = textField.formatter as! NumberFormatter
            numFormatter.maximum = newValue as NSNumber
            stepper.maxValue = Double(newValue)
        }
    }

    @IBAction func changeValue(_ sender: AnyObject)
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
        if newValue != nil
        {
            self.sendAction(self.action, to: self.target)
        }
    }

}

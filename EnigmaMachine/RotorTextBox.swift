//
//  RotorTextBox.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 11/03/2015.
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

/**

Overriding the text box seems to be the only way to accept a drag operation.

*/
class RotorTextBox: NSTextField
{
    @IBOutlet weak var enigmaController: AbstractEnigmaController!
    @IBOutlet weak var stepper: NSStepper!

    var lastStepperValue = 0

    var letter: Letter?
    {
		didSet(oldValue)
        {
            if let letter = letter
            {
                self.stringValue = String(letter.rawValue)
            }
            else
            {
                self.stringValue = ""
            }
        }
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation
    {
        var ret: NSDragOperation = []
        if enigmaController.rotorBeingDragged != nil
        {
			ret = NSDragOperation.move
        }
        return ret
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool
    {
        return enigmaController.finishDrag(targetRotorTexBox: self)
    }

    @IBAction func stepperChanged(_ sender: AnyObject)
    {
        let thisStepperValue = stepper.integerValue
        let difference = thisStepperValue - lastStepperValue
        lastStepperValue = stepper.integerValue

        enigmaController.stepRotor(rotorTextBox: self, increment: difference)
    }

    override func mouseDown(with theEvent: NSEvent)
    {
        enigmaController.showPopover(rotorTextBox: self)
    }
}

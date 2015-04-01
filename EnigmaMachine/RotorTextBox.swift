//
//  RotorTextBox.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 11/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

/**

Overriding the text box seems to be the only way to accept a drag operation.

*/
class RotorTextBox: NSTextField
{
    @IBOutlet weak var enigmaController: AbstractEnigmaController!
    @IBOutlet weak var stepper: NSStepper!

    var lastStepperValue = 0

    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation
    {
        var ret = NSDragOperation.None
        if enigmaController.rotorBeingDragged != nil
        {
			ret = NSDragOperation.Move
        }
        return ret
    }

    override func performDragOperation(sender: NSDraggingInfo) -> Bool
    {
        return enigmaController.finishDrag(self)
    }

    @IBAction func stepperChanged(sender: AnyObject)
    {
        let thisStepperValue = stepper.integerValue
        let difference = thisStepperValue - lastStepperValue
        lastStepperValue = stepper.integerValue

        enigmaController.stepRotor(rotorTextBox: self, increment: difference)
    }

    override func mouseDown(theEvent: NSEvent)
    {
        println("mouse down")
        enigmaController.showPopover(rotorTextBox: self)
    }
}
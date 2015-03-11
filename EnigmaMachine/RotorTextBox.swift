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

    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation
    {
        var ret = NSDragOperation.None
        if enigmaController.rotorBeingDragged != nil
        {
            println("Dragging entered");
			ret = NSDragOperation.Move
        }
        return ret
    }

    override func performDragOperation(sender: NSDraggingInfo) -> Bool
    {
        var ret: Bool = false
        if let rotorBeingDragged = enigmaController.rotorBeingDragged
        {
            println("perform drag");
            if let identifier = self.identifier
            {
                let ringIndex = identifier.toInt()!
                if let removedRotor = enigmaController.enigmaMachine.removeRotorFromSlot(ringIndex)
                {
                    enigmaController.rotorBoxDataSource.insertRotor(removedRotor)
                }
                enigmaController.enigmaMachine.insertRotor(rotorBeingDragged, inSlot: ringIndex,
                    														position: Letter.A)
                enigmaController.rotorBeingDragged = nil
            }

			ret = true
        }
        return ret
    }

}
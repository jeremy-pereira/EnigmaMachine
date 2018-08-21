//
//  RotorBoxController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 30/03/2015.
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

class RotorInBoxView: NSTableCellView
{
    override var objectValue: Any?
    {
        didSet(oldValue)
        {
            if let ring = objectValue as? Rotor
            {
                textField?.stringValue = String(ring.name)
            }
        }
    }
}

class RingStellungView: NSTableCellView
{
    @IBOutlet weak var stepper: NSStepper!

    override var objectValue: Any?
    {
		didSet(oldValue)
        {
			if let ring = objectValue as? Rotor
            {
                textField?.stringValue = String(ring.ringStellung.rawValue)
                stepper.integerValue = ring.ringStellung.ordinal
            }
        }
    }

    @IBAction func stepperChanged(_ sender: AnyObject?)
    {
        if let ring = objectValue as? Rotor
        {
            let newLetter = Letter.letter(ordinal: stepper.integerValue)
            ring.ringStellung = newLetter
            objectValue = ring
        }
    }
}

class RotorBoxTableView: NSTableView
{
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool
    {
        return responder is NSStepper || super.validateProposedFirstResponder(responder, for: event)
    }
}


class  RotorBoxController: NSObject, NSTableViewDataSource, NSTableViewDelegate
{
    @IBOutlet weak var rotorBoxView: NSTableView!
    @IBOutlet weak var enigmaController: AbstractEnigmaController!

    private var rotorBox: SpareRotorBox = SpareRotorBox()

   func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.rotorBox.count
    }

    func insertRotor(newRotor: Rotor)
    {
        self.rotorBox.add(newRotor: newRotor)
        self.rotorBoxView.reloadData()
    }

    func removeRotor(rotor: Rotor) ->Rotor?
    {
        let ret = rotorBox.remove(rotor: rotor)
        if ret != nil
        {
            self.rotorBoxView.reloadData()
        }
        return ret
    }

    func tableView(_     tableView: NSTableView,
        objectValueFor tableColumn: NSTableColumn?,
                               row: Int) -> Any?
    {
        var ret: AnyObject?
        let rotor = rotorBox.rotor(row)
        if let rotor = rotor
        {
            ret = rotor
        }
        return ret
    }

    func tableView(_   tableView: NSTableView,
        writeRowsWith rowIndexes: IndexSet,
        			   to pboard: NSPasteboard) -> Bool
    {
        assert(rowIndexes.count == 1, "Cannot handle drag of multiple rotors")
        let draggingRotor = rotorBox.rotor[rowIndexes.first!]
        enigmaController.rotorBeingDragged = draggingRotor
        let wrapper = RotorPasteBoardWrapper(rotor: draggingRotor)
        pboard.writeObjects([wrapper])
        return true
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        var result: NSTableCellView?
        if let tableColumn = tableColumn
        {
            result = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView
            if let result = result
            {
                result.objectValue
                    = self.tableView(tableView, objectValueFor: tableColumn, row: row)
            }
        }
        return result
    }
}

//
//  RotorBoxController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 30/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa


class  RotorBoxController: NSObject, NSTableViewDataSource, NSTableViewDelegate
{
    @IBOutlet weak var rotorBoxView: NSTableView!
    @IBOutlet weak var enigmaController: AbstractEnigmaController!

    private var rotorBox: SpareRotorBox = SpareRotorBox()

   func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.rotorBox.count
    }

    func insertRotor(newRotor: Rotor)
    {
        self.rotorBox.add(newRotor)
        self.rotorBoxView.reloadData()
    }

    func removeRotor(rotor: Rotor) ->Rotor?
    {
        let ret = rotorBox.removeRotor(rotor)
        if ret != nil
        {
            self.rotorBoxView.reloadData()
        }
        return ret
    }

    func tableView(                 tableView: NSTableView,
        objectValueForTableColumn tableColumn: NSTableColumn?,
        row: Int) -> AnyObject?
    {
        var ret: NSString?
        let rotor = rotorBox.rotor(row)
        if let rotor = rotor
        {
            if tableColumn?.identifier == "ring"
            {
                ret = rotor.name
            }
            else if tableColumn?.identifier == "ringStellung"
            {
                ret = "\(rotor.ringStellung.rawValue)"
            }
        }
        return ret
    }

    func tableView(           tableView: NSTableView,
        writeRowsWithIndexes rowIndexes: NSIndexSet,
        toPasteboard pboard: NSPasteboard) -> Bool
    {
        assert(rowIndexes.count == 1, "Cannot handle drag of multiple rotors")
        let draggingRotor = rotorBox.rotor[rowIndexes.firstIndex]
        enigmaController.rotorBeingDragged = draggingRotor
        let wrapper = RotorPasteBoardWrapper(rotor: draggingRotor)
        pboard.writeObjects([wrapper])
        return true
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        var result: NSTableCellView?
        if let tableColumn = tableColumn
        {
            result = tableView.makeViewWithIdentifier(tableColumn.identifier!, owner: self) as? NSTableCellView
            if let result = result
            {
                result.textField!.stringValue
                    = self.tableView(tableView, objectValueForTableColumn: tableColumn, row: row) as! String
            }
        }
        return result
    }
}

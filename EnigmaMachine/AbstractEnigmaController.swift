//
//  AbstractEnigmaController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class  RotorBoxDataSource: NSObject, NSTableViewDataSource
{
    private var rotorBox: SpareRotorBox

    init(rotorBox: SpareRotorBox)
    {
        self.rotorBox = rotorBox
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.rotorBox.count
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
}

class AbstractEnigmaController: NSWindowController, EnigmaObserver
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()
    var rotorBoxDataSource = RotorBoxDataSource(rotorBox: SpareRotorBox())

    @IBOutlet var ringDisplay1: NSTextField!
    @IBOutlet var ringDisplay2: NSTextField!
    @IBOutlet var ringDisplay3: NSTextField!
    @IBOutlet var outputLetters: NSTextField!
    @IBOutlet var rotorBoxView: NSTableView!

	override convenience init()
    {
        self.init(windowNibName: "AbstractEnigmaWindow")
    }

    override func windowDidLoad()
    {
        enigmaMachine.registerObserver(self)
        enigmaMachine.insertReflector(reflectorB, position: Letter.A)
        enigmaMachine.insertRotor(RotorI(), inSlot: 2, position: Letter.A)
        enigmaMachine.insertRotor(RotorII(), inSlot: 1, position: Letter.A)
        enigmaMachine.insertRotor(RotorIII(), inSlot: 0, position: Letter.A)
        rotorBoxView.setDataSource(rotorBoxDataSource)
    }

    func stateChanged(machine: EnigmaMachine)
    {
        var displayLetters = enigmaMachine.rotorReadOut
        if let letter = displayLetters[2]
        {
            ringDisplay1.stringValue = String(letter.rawValue)
        }
        if let letter = displayLetters[1]
        {
            ringDisplay2.stringValue = String(letter.rawValue)
        }
        if let letter = displayLetters[0]
        {
            ringDisplay3.stringValue = String(letter.rawValue)
        }
    }

    @IBAction func keyPressed(sender: AnyObject)
    {
		if let key = sender as? NSButton
        {
			if let identifier = key.identifier
            {
                let idUpperCase = identifier.uppercaseString
                let idChar = idUpperCase[idUpperCase.startIndex]
                let letter = Letter(rawValue: idChar)
                enigmaMachine.keyDown(letter!)
                if let outputLetter = enigmaMachine.litLamp
                {
					outputLetters.stringValue.append(outputLetter.rawValue)
                }
                enigmaMachine.keyUp()
            }
        }
    }
}
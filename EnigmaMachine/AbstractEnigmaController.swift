//
//  AbstractEnigmaController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

@objc class RotorPasteBoardWrapper: NSObject, NSPasteboardWriting, NSPasteboardReading
{
    var rotor: Rotor

    init(rotor: Rotor)
    {
        self.rotor = rotor
    }

    required init!(pasteboardPropertyList propertyList: AnyObject!, ofType type: String!)
    {
        self.rotor = Rotor.makeMilitaryI()
    }

    // MARK: Writing

    func writableTypesForPasteboard(pasteboard: NSPasteboard!) -> [AnyObject]!
    {
        return RotorPasteBoardWrapper.readableTypesForPasteboard(pasteboard)
    }

    func writingOptionsForType(type: String!, pasteboard: NSPasteboard!) -> NSPasteboardWritingOptions
    {
        return NSPasteboardWritingOptions(0)
    }

    func pasteboardPropertyListForType(type: String!) -> AnyObject!
    {
        var ret: String?

        if type == NSPasteboardTypeString
        {
			ret = "\(rotor.name), \(rotor.ringStellung)"
        }
        return ret
    }

    // MARK: Reading

    class func readableTypesForPasteboard(pasteboard: NSPasteboard!) -> [AnyObject]!
    {
        return [NSPasteboardTypeString]
    }
}

class  RotorBoxDataSource: NSObject, NSTableViewDataSource
{
    private var rotorBox: SpareRotorBox
    weak var enigmaController: AbstractEnigmaController!

    init(rotorBox: SpareRotorBox)
    {
        self.rotorBox = rotorBox
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.rotorBox.count
    }

    func insertRotor(newRotor: Rotor)
    {
        self.rotorBox.add(newRotor)
        self.enigmaController.rotorBoxView.reloadData()
    }

    func removeRotor(rotor: Rotor) ->Rotor?
    {
        let ret = rotorBox.removeRotor(rotor)
        if ret != nil
        {
            enigmaController.rotorBoxView.reloadData()
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
}

class AbstractEnigmaController:
    NSWindowController, EnigmaObserver, PlugboardViewDataSource, KeyboardDelegate
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()
    var rotorBeingDragged: Rotor?
    var rotorBoxDataSource: RotorBoxDataSource = RotorBoxDataSource(rotorBox: SpareRotorBox())

    @IBOutlet var ringDisplay1: NSTextField!
    @IBOutlet var ringDisplay2: NSTextField!
    @IBOutlet var ringDisplay3: NSTextField!
    @IBOutlet var rotorBoxView: NSTableView!
    @IBOutlet var printerController: PrinterController!
    @IBOutlet var plugboardView: PlugboardView!
    @IBOutlet var lightPanelView: LightPanelView!
    @IBOutlet var keyboard: KeyboardView!

	convenience init()
    {
        self.init(windowNibName: "AbstractEnigmaWindow")
        rotorBoxDataSource.enigmaController = self
    }

    override func windowDidLoad()
    {
        enigmaMachine.registerObserver(self)
        enigmaMachine.insertReflector(reflectorB, position: Letter.A)
        rotorBoxView.setDataSource(rotorBoxDataSource)
        ringDisplay1.registerForDraggedTypes([NSPasteboardTypeString])
        ringDisplay2.registerForDraggedTypes([NSPasteboardTypeString])
        ringDisplay3.registerForDraggedTypes([NSPasteboardTypeString])
        plugboardView.backgroundColour = NSColor.whiteColor()
        plugboardView.needsDisplay = true
        plugboardView.dataSource = self
        lightPanelView.backgroundColour = NSColor.whiteColor()
        keyboard.keyboardDelegate = self
        self.window?.delegate = self
        positionPrinterToTheRight();
    }

    func positionPrinterToTheRight()
    {
        if let myFrame = self.window?.frame,
               printerWindow = printerController.window
        {
			var newTopLeft = NSPoint()
            newTopLeft.y = myFrame.origin.y + myFrame.size.height
            newTopLeft.x = myFrame.origin.x + myFrame.size.width + 8
			printerWindow.setFrameTopLeftPoint(newTopLeft)
        }
    }

    @IBAction func showOrHidePrinter(sender: AnyObject?)
    {
        if printerIsVisible
        {
            printerController.window?.performClose(sender)
        }
        else
        {
            printerController.showWindow(sender)
        }
    }

    var printerIsVisible: Bool
    {
		return printerController.windowIsVisible
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
        lightPanelView.litLetter = enigmaMachine.litLamp
    }

    private var lastLetter: Letter?

    override func keyDown(theEvent: NSEvent)
    {
        if let characters = theEvent.characters
        {
            enigmaMachine.keyUp()
            let uppercaseChars = characters.uppercaseString
            let theChar = uppercaseChars[uppercaseChars.startIndex]
			if let letter = Letter(rawValue: theChar)
            {
                letterPressed(letter, keyboard: keyboard)
            }
        }
    }

    override func keyUp(theEvent: NSEvent)
    {
        letterReleased(keyboard: keyboard)
    }

    // MARK: PlugboardView data source methods

    func connectLetterPair(letterPair: (Letter, Letter), plugboardView: PlugboardView)
    {
        enigmaMachine.plugInPair(letterPair)
    }

    func connectionForLetter(letter: Letter, plugboardView: PlugboardView) -> Letter?
    {
        return enigmaMachine.plugboard.letterConnectedTo(letter: letter)
    }

    // MARK: KeyboardDelegate

    func letterPressed(aLetter: Letter, keyboard: KeyboardView)
    {
        enigmaMachine.keyUp()
        enigmaMachine.keyDown(aLetter)
        if let outputLetter = enigmaMachine.litLamp
        {
            printerController.displayLetter(outputLetter)
        }
    }

    func letterReleased(#keyboard: KeyboardView)
    {
        enigmaMachine.keyUp()
    }

}

extension AbstractEnigmaController: NSWindowDelegate
{
    func windowDidMove(notification: NSNotification)
    {
		positionPrinterToTheRight()
    }
}
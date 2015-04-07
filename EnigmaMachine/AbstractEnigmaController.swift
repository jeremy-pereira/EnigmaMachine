//
//  AbstractEnigmaController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class RotorPopoverController: NSViewController
{
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var ringStellung: NSTextField!

}

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

class AbstractEnigmaController:
    NSWindowController, EnigmaObserver
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()
    var rotorBeingDragged: Rotor?

    @IBOutlet var rotorBoxDataSource: RotorBoxController!

    @IBOutlet weak var ringDisplay1: RotorTextBox!
    @IBOutlet weak var ringDisplay2: RotorTextBox!
    @IBOutlet weak var ringDisplay3: RotorTextBox!
    @IBOutlet weak var printerController: PrinterController!
    @IBOutlet weak var plugboardView: PlugboardView!
    @IBOutlet weak var lightPanelView: LightPanelView!
    @IBOutlet weak var keyboard: KeyboardView!
    @IBOutlet weak var popover: NSPopover!

	convenience init()
    {
        self.init(windowNibName: "AbstractEnigmaWindow")
    }

    override func windowDidLoad()
    {
        enigmaMachine.registerObserver(self)
        enigmaMachine.insertReflector(reflectorB, position: Letter.A)
        ringDisplay1.registerForDraggedTypes([NSPasteboardTypeString])
        ringDisplay2.registerForDraggedTypes([NSPasteboardTypeString])
        ringDisplay3.registerForDraggedTypes([NSPasteboardTypeString])
        plugboardView.backgroundColour = NSColor.whiteColor()
        plugboardView.needsDisplay = true
        plugboardView.dataSource = self
        lightPanelView.backgroundColour = NSColor.whiteColor()
        keyboard.keyboardDelegate = self
        self.window?.delegate = self
        positionPrinterToTheRightOrLeft();
    }

    func positionPrinterToTheRightOrLeft()
    {
        if let myWindow = self.window,
               printerWindow = printerController.window
        {
            let myFrame = myWindow.frame
            var screen = myWindow.screen

            var printerFrame = printerWindow.frame
			var newTopLeft = NSPoint()
            let margin: CGFloat = 4

            newTopLeft.y = myFrame.origin.y + myFrame.size.height
            newTopLeft.x = myFrame.origin.x + myFrame.size.width + margin
            /*
			 *  If we have a screen (i.e. the main window is not completely off
			 *  screen and we are near the right edge, we will actually position
             *  the window to the left.
             *
             *  We make the assumption that there definitely is room to the left 
             *  if there isn't room to the right.
			 */
            if let screen = screen
            {
				let screenLimit = screen.visibleFrame
                if newTopLeft.x + printerFrame.size.width > screenLimit.origin.x + screenLimit.size.width
                {
                    newTopLeft.x = myFrame.origin.x - margin - printerFrame.size.width
                }
            }
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

    @IBAction func arrangePrinter(sender: AnyObject?)
    {
        positionPrinterToTheRightOrLeft();
    }

    var printerIsVisible: Bool
    {
		return printerController.windowIsVisible
    }

    func stateChanged(machine: EnigmaMachine)
    {
        var displayLetters = enigmaMachine.rotorReadOut
        ringDisplay1.letter = displayLetters[2]
        ringDisplay2.letter = displayLetters[1]
        ringDisplay3.letter = displayLetters[0]
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

    func finishDrag(targetRotorTexBox: RotorTextBox) -> Bool
    {
        var ret: Bool = false

        if let rotorBeingDragged = rotorBeingDragged
        {
            rotorBoxDataSource.removeRotor(rotorBeingDragged)
            if let identifier = targetRotorTexBox.identifier
            {
                let ringIndex = identifier.toInt()!
                if let removedRotor = enigmaMachine.removeRotorFromSlot(ringIndex)
                {
                    rotorBoxDataSource.insertRotor(removedRotor)
                }
                enigmaMachine.insertRotor(rotorBeingDragged, inSlot: ringIndex, position: Letter.A)
                self.rotorBeingDragged = nil
            }
            ret = true
        }
		return ret
    }

    func stepRotor(#rotorTextBox: RotorTextBox, increment: Int)
    {
        let slotNumber = rotorTextBox.identifier!.toInt()!

        if let rotorPosition = enigmaMachine.rotorPositionForSlot(slotNumber)
        {
            let newRotorPosition = rotorPosition &+ increment
            enigmaMachine.setRotorPosition(newRotorPosition, slotNumber: slotNumber)
        }
    }

    private var popoverSlotNumber: Int?

    func showPopover(#rotorTextBox: RotorTextBox)
    {
        if let popover = popover
        {
            let controller = popover.contentViewController as! RotorPopoverController
            let slotNumber = rotorTextBox.identifier!.toInt()!
            if let rotor = enigmaMachine.rotorCradle.slot[slotNumber].rotor
            {
                popoverSlotNumber = slotNumber
				controller.name.stringValue = rotor.name
                controller.ringStellung.stringValue = String(rotor.ringStellung.rawValue)
                popover.showRelativeToRect(rotorTextBox.bounds, ofView: rotorTextBox, preferredEdge: 3)
            }
        }
    }

    @IBAction func putInBox(sender: AnyObject?)
    {
        if let popoverSlotNumber = popoverSlotNumber
        {
            if let rotor = enigmaMachine.removeRotorFromSlot(popoverSlotNumber)
            {
				rotorBoxDataSource.insertRotor(rotor)
            }
            self.popoverSlotNumber = nil
        }
    }
}

// MARK: -
// MARK: KeyboardDelegate
extension AbstractEnigmaController: KeyboardDelegate
{


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


// MARK: -
// MARK: PlugboardView data source methods
extension AbstractEnigmaController: PlugboardViewDataSource
{

    func connectLetterPair(letterPair: (Letter, Letter), plugboardView: PlugboardView)
    {
        enigmaMachine.plugInPair(letterPair)
    }

    func connectionForLetter(letter: Letter, plugboardView: PlugboardView) -> Letter?
    {
        return enigmaMachine.plugboard.letterConnectedTo(letter: letter)
    }
}


// MARK: -
extension AbstractEnigmaController: NSWindowDelegate
{
}
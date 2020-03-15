//
//  AbstractEnigmaController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015, 2018 Jeremy Pereira. All rights reserved.
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

    required init!(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType)
    {
        self.rotor = Rotor.makeMilitaryI()
    }

    // MARK: Writing

    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType]
    {
        return RotorPasteBoardWrapper.readableTypes(for: pasteboard)
    }

    func writingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.WritingOptions
    {
        return NSPasteboard.WritingOptions(rawValue: 0)
    }

    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any?
    {
        var ret: String?

        if type == NSPasteboard.PasteboardType.string
        {
			ret = "\(rotor.name), \(rotor.ringStellung)"
        }
        return ret
    }

    // MARK: Reading

    class func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType]
    {
        return [NSPasteboard.PasteboardType.string]
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
        enigmaMachine.register(observer: self)
        enigmaMachine.insert(reflector: reflectorB, position: Letter.A)
        ringDisplay1.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        ringDisplay2.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        ringDisplay3.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        plugboardView.backgroundColour = NSColor.white
        plugboardView.needsDisplay = true
        plugboardView.dataSource = self
        lightPanelView.backgroundColour = NSColor.white
        keyboard.keyboardDelegate = self
        self.window?.delegate = self
        positionPrinterToTheRightOrLeft();
    }

    func positionPrinterToTheRightOrLeft()
    {
        if let myWindow = self.window,
            let printerWindow = printerController.window
        {
            let myFrame = myWindow.frame
            let screen = myWindow.screen

            let printerFrame = printerWindow.frame
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

    @IBAction func showOrHidePrinter(_ sender: AnyObject?)
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

    @IBAction func arrangePrinter(_ sender: AnyObject?)
    {
        positionPrinterToTheRightOrLeft();
    }

    var printerIsVisible: Bool
    {
		return printerController.windowIsVisible
    }

    func stateChanged(machine: EnigmaMachine)
    {
		let displayLetters = enigmaMachine.rotorReadOut
        ringDisplay1.letter = displayLetters[2]
        ringDisplay2.letter = displayLetters[1]
        ringDisplay3.letter = displayLetters[0]
        lightPanelView.litLetter = enigmaMachine.litLamp
    }

    private var lastLetter: Letter?

    override func keyDown(with theEvent: NSEvent)
    {
        if let characters = theEvent.characters
        {
            enigmaMachine.keyUp()
            let uppercaseChars = characters.uppercased()
            let theChar = uppercaseChars[uppercaseChars.startIndex]
			if let letter = Letter(rawValue: theChar)
            {
                letterPressed(aLetter: letter, keyboard: keyboard)
            }
        }
    }

    override func keyUp(with theEvent: NSEvent)
    {
        letterReleased(keyboard: keyboard)
    }

    func finishDrag(targetRotorTexBox: RotorTextBox) -> Bool
    {
        var ret: Bool = false

        if let rotorBeingDragged = rotorBeingDragged
        {
            _ = rotorBoxDataSource.removeRotor(rotor: rotorBeingDragged)
            if let identifier = targetRotorTexBox.identifier
            {
                let ringIndex = Int(identifier.rawValue)!
                if let removedRotor = enigmaMachine.removeRotorFromSlot(slotNumber: ringIndex)
                {
                    rotorBoxDataSource.insertRotor(newRotor: removedRotor)
                }
                enigmaMachine.insert(rotor: rotorBeingDragged, inSlot: ringIndex, position: Letter.A)
                self.rotorBeingDragged = nil
            }
            ret = true
        }
		return ret
    }

    func stepRotor(rotorTextBox: RotorTextBox, increment: Int)
    {
        let slotNumber = Int(rotorTextBox.identifier!.rawValue)!

        if let rotorPosition = enigmaMachine.rotorPositionForSlot(slotNumber: slotNumber)
        {
            let newRotorPosition = rotorPosition &+ increment
            enigmaMachine.setRotorPosition(newPosition: newRotorPosition, slotNumber: slotNumber)
        }
    }

    private var popoverSlotNumber: Int?

    func showPopover(rotorTextBox: RotorTextBox)
    {
        if let popover = popover
        {
            let controller = popover.contentViewController as! RotorPopoverController
            let slotNumber = Int(rotorTextBox.identifier!.rawValue)!
            if let rotor = enigmaMachine.rotorCradle.slot[slotNumber].rotor
            {
                popoverSlotNumber = slotNumber
				controller.name.stringValue = rotor.name
                controller.ringStellung.stringValue = String(rotor.ringStellung.rawValue)
                popover.show(relativeTo: rotorTextBox.bounds, of: rotorTextBox, preferredEdge: .maxY)
            }
        }
    }

    @IBAction func putInBox(_ sender: AnyObject?)
    {
        if let popoverSlotNumber = popoverSlotNumber
        {
            if let rotor = enigmaMachine.removeRotorFromSlot(slotNumber: popoverSlotNumber)
            {
                rotorBoxDataSource.insertRotor(newRotor: rotor)
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
        enigmaMachine.keyDown(aLetter: aLetter)
        if let outputLetter = enigmaMachine.litLamp
        {
            printerController.display(letter: outputLetter)
        }
    }

    func letterReleased(keyboard: KeyboardView)
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
        enigmaMachine.plugIn(pair: letterPair)
    }

    func connectionForLetter(letter: Letter, plugboardView: PlugboardView) -> Letter?
    {
        return enigmaMachine.plugboard.letterConnectedTo(letter: letter)
    }
}


// MARK: -
extension AbstractEnigmaController: NSWindowDelegate
{
    func windowWillClose(_ notification: Notification)
    {
        printerController.window?.performClose(self)
    }
}

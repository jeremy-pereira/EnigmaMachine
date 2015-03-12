//
//  PrinterController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 12/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class PrinterController: NSWindowController
{
    @IBOutlet var outputLetters: NSTextField!

    override func windowDidLoad()
    {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window 
        // controller's window has been loaded from its nib file.
    }

    func displayLetter(letter: Letter)
    {
        outputLetters.stringValue.append(letter.rawValue)
    }
}

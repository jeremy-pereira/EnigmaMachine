//
//  TestButton.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class TestButton: NSButton {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }

    override var isChecked: Bool
    {
		didSet(oldValue)
        {
            println("Hello");
        }
    }
}

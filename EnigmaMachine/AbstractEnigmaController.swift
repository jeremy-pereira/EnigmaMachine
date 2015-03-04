//
//  AbstractEnigmaController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class AbstractEnigmaController: NSWindowController
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()
    
	override convenience init()
    {
        self.init(windowNibName: "AbstractEnigmaWindow")
    }
}
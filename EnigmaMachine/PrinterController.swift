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
    @IBOutlet var lettersScroller: NSScrollView!
    @IBOutlet var groupSize: StepperView!
    @IBOutlet var groupsPerLine: StepperView!


    override func windowDidLoad()
    {
        super.windowDidLoad()

		println("PrinterController nib loaded")

    }

	override func awakeFromNib()
	{
		groupSize.integerValue = 5
        groupSize.minimum = 1
        groupSize.maximum = 80
		groupsPerLine.integerValue = 8
        groupsPerLine.minimum = 1
        groupsPerLine.maximum = 20
	}

    private var letters: [Letter] = []

    func displayLetter(letter: Letter)
    {
        let letterCount = letters.count

        if letterCount % groupSize.integerValue == 0 && letterCount != 0
        {
            let groupCount = letterCount / groupSize.integerValue
            if groupCount % groupsPerLine.integerValue == 0
            {
                outputLetters.stringValue += "\n"
            }
            else
            {
                outputLetters.stringValue += " "
            }
        }
        outputLetters.stringValue.append(letter.rawValue)
        letters.append(letter)
        //lettersScroller.contentView.scrollToPoint(NSMakePoint(0.0, 0.0))
    }

    func redisplayLetters()
    {
        let savedLetters = letters
        letters = []
        outputLetters.stringValue = ""
        for letter in savedLetters
        {
            displayLetter(letter)
        }
    }

	@IBAction func clearOutput(sender: AnyObject)
	{
        letters = []
        redisplayLetters()
	}

	@IBAction func changeGroupSize(sender: AnyObject)
	{
        redisplayLetters()
	}
    @IBAction func changeLineWrap(sender: AnyObject)
    {
        redisplayLetters()
    }
}

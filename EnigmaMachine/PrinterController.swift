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

	private var letterCount: Int = 0
    func displayLetter(letter: Letter)
    {
        if letterCount % groupSize.integerValue == 0 && letterCount != 0
        {
			outputLetters.stringValue += " "
        }
        outputLetters.stringValue.append(letter.rawValue)
        letterCount++
        //lettersScroller.contentView.scrollToPoint(NSMakePoint(0.0, 0.0))
    }

	@IBAction func clearOutput(sender: AnyObject)
	{
		outputLetters.stringValue = ""
		letterCount = 0
	}

	@IBAction func changeGroupSize(sender: AnyObject)
	{
//        var newGroupSize: Int?
//        if sender === groupSize
//        {
//            newGroupSize = groupSize.integerValue
//            groupStepper.integerValue = newGroupSize!
//        }
//        else if sender === groupStepper
//        {
//            newGroupSize = groupStepper.integerValue
//            groupSize.integerValue = newGroupSize!
//        }
//        if let newGroupSize = newGroupSize
//        {
//            var strippedOutput = outputLetters.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "")
//            var index = strippedOutput.startIndex
//            var newOutput = ""
//            var count = 0
//            while index < strippedOutput.endIndex
//            {
//				if count % newGroupSize == 0 && count != 0
//                {
//                    newOutput.append(Character(" "))
//                }
//                newOutput.append(strippedOutput[index])
//                count++
//                index++
//            }
//            outputLetters.stringValue = newOutput
//        }
	}
}

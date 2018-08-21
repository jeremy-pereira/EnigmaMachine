//
//  PrinterController.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 12/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
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

class PrinterController: NSWindowController, NSWindowDelegate
{
    @IBOutlet weak var outputLetters: NSTextField!
    @IBOutlet weak var lettersScroller: NSScrollView!
    @IBOutlet weak var groupSize: StepperView!
    @IBOutlet weak var groupsPerLine: StepperView!

    var applicationDelegate: AppDelegate
    {
        return NSApplication.shared.delegate as! AppDelegate
    }

    var windowIsVisible: Bool = true
    {
		didSet(oldValue)
        {
            if let currentEnigma = applicationDelegate.currentEnigma
            {
                applicationDelegate.setShowPrinterTitle(printerIsVisible: currentEnigma.printerIsVisible)
            }
        }
    }

    override func windowDidLoad()
    {
        super.windowDidLoad()

		print("PrinterController nib loaded")
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

    func display(letter: Letter)
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
        let height = outputLetters.frame.size.height - lettersScroller.contentView.bounds.size.height
        if height > 0
        {
            lettersScroller.contentView.scroll(to: NSMakePoint(0.0, height))
            lettersScroller.reflectScrolledClipView(lettersScroller.contentView)
        }
    }

    func redisplayLetters()
    {
        let savedLetters = letters
        letters = []
        outputLetters.stringValue = ""
        for letter in savedLetters
        {
            display(letter: letter)
        }
    }

	@IBAction func clearOutput(sender: Any)
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

    override func showWindow(_ sender: Any?)
    {
        super.showWindow(sender)
        windowIsVisible = true
    }

    // MARK: Window delegate

    func windowWillClose(_ notification: Notification)
    {
        windowIsVisible = false
    }
}

//
//  KeyboardButton.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 23/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa


protocol KeyboardDelegate: AnyObject
{
    func letterPressed(aLetter: Letter, keyboard: KeyboardView);
    func letterReleased(#keyboard: KeyboardView);
}

class KeyboardView: NSBox
{
    weak var keyboardDelegate: KeyboardDelegate?
    var timer: NSTimer?

    @IBOutlet var singleStep: AutoKeyButton!
    @IBOutlet var autoInput: NSSegmentedControl!

    @IBAction func keyPressed(sender: AnyObject)
    {
        if let keyboardButton = sender as? KeyboardButton, keyboardDelegate = keyboardDelegate
        {
            keyboardDelegate.letterReleased(keyboard: self)
        }
    }

    func buttonPressed(keyboardButton : KeyboardButton)
    {
        if let keyboardDelegate = keyboardDelegate, letter = keyboardButton.letter
        {
            keyboardDelegate.letterPressed(letter, keyboard: self)
        }
    }

    var timerShouldStop = false;
    var timerMouseUp = false;

    @IBAction func toggleTimer(sender: AnyObject)
    {
        if timer != nil
        {
            timerShouldStop = true;
        }
        else
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                                                              selector: "timer:",
                                                              userInfo: nil,
                                                               repeats: true)
        }
    }


    @objc func timer(userInfo: AnyObject?)
    {
		if timerMouseUp
        {
            timerMouseUp = false

            self.keyPressed(singleStep)
            let now = NSDate()
            println("Toggle off \(now)")

			if timerShouldStop
            {
                timer?.invalidate()
                timer = nil;
                timerShouldStop = false
            }
        }
        else
        {
            timerMouseUp = true

            singleStep.fixUpIdentifier()
            self.buttonPressed(singleStep)

        }
    }
}

class KeyboardButton: NSButton
{
    var keyboard: KeyboardView?
    {
		get
        {
            var ret: KeyboardView?
            var ancestorView = self.superview
            while ancestorView != nil && ret == nil
            {
                if let keyboardView = ancestorView as? KeyboardView
                {
                    ret = keyboardView
                }
                ancestorView = ancestorView?.superview
            }
            return ret
        }
    }

    var letter: Letter?
    {
        var ret: Letter?
        if let identifier = self.identifier
        {
            if identifier != ""
            {
                var idChar = identifier[identifier.startIndex]
                if idChar != "$"
                {
                    ret = Letter(rawValue: idChar)
                }
            }
        }
        return ret
    }

    override func mouseDown(theEvent: NSEvent)
    {
        if let keyboard = keyboard
        {
            keyboard.buttonPressed(self)
        }
        super.mouseDown(theEvent)
    }

}

class AutoKeyButton: KeyboardButton
{
    @IBOutlet var textField: NSTextField!

    override func mouseDown(theEvent: NSEvent)
    {
		fixUpIdentifier()
        super.mouseDown(theEvent)
    }

    func fixUpIdentifier()
    {
        let rawCharacters = textField.stringValue
        let charactersLeft = rawCharacters.uppercaseString
        var nextLetter: Letter?
        var chosenIndex: String.Index = rawCharacters.startIndex
        for var index = charactersLeft.startIndex ;
            nextLetter == nil && index != charactersLeft.endIndex ;
            ++index, ++chosenIndex
        {
            if let candidateLetter = Letter(rawValue: charactersLeft[index])
            {
                if candidateLetter != Letter.UpperBound // Could be, if they typed a $
                {
                    nextLetter = candidateLetter
                    chosenIndex = index
                }
            }
        }
        var  replacementString = ""
        if let nextLetter = nextLetter
        {
            self.identifier = String(nextLetter.rawValue)
            if chosenIndex != rawCharacters.endIndex
            {
                for aChar in rawCharacters[chosenIndex ..< rawCharacters.endIndex]
                {
                    replacementString.append(aChar)
                }
            }
        }
        else
        {
            self.identifier = ""
        }
        textField.stringValue = replacementString
    }
}

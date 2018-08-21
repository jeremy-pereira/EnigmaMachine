//
//  KeyboardButton.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 23/03/2015.
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


protocol KeyboardDelegate: AnyObject
{
    func letterPressed(aLetter: Letter, keyboard: KeyboardView);
    func letterReleased(keyboard: KeyboardView);
}

class KeyboardView: NSBox
{
    weak var keyboardDelegate: KeyboardDelegate?
    var timer: Timer?

    @IBOutlet var singleStep: AutoKeyButton!
    @IBOutlet var autoInput: NSSegmentedControl!

    @IBAction func keyPressed(_ sender: AnyObject)
    {
        if let _ = sender as? KeyboardButton, let keyboardDelegate = keyboardDelegate
        {
            keyboardDelegate.letterReleased(keyboard: self)
        }
    }

    func buttonPressed(keyboardButton : KeyboardButton)
    {
        if let keyboardDelegate = keyboardDelegate, let letter = keyboardButton.letter
        {
            keyboardDelegate.letterPressed(aLetter: letter, keyboard: self)
        }
    }

    var timerShouldStop = false;
    var timerMouseUp = false;

    @IBAction func toggleTimer(_ sender: AnyObject)
    {
        if timer != nil
        {
            timerShouldStop = true;
        }
        else
        {
            timer = Timer(timeInterval: 0.1, repeats: true)
            {
                _ in
                self.timerFired()
            }
        }
    }


    func timerFired()
    {
		if timerMouseUp
        {
            timerMouseUp = false

            self.keyPressed(singleStep)

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
            self.buttonPressed(keyboardButton: singleStep)

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
        if self.title != ""
        {
            let idChar = self.title[self.title.startIndex]
            if idChar != "$"
            {
                ret = Letter(rawValue: idChar)
            }
        }
        return ret
    }

    override func mouseDown(with theEvent: NSEvent)
    {
        if let keyboard = keyboard
        {
            keyboard.buttonPressed(keyboardButton: self)
        }
        super.mouseDown(with: theEvent)
    }

}

class AutoKeyButton: KeyboardButton
{
    @IBOutlet var textField: NSTextField!

    override func mouseDown(with theEvent: NSEvent)
    {
		fixUpIdentifier()
        super.mouseDown(with: theEvent)
    }

    var _letter: Letter?

    override var letter: Letter?
    {
		get
        {
            return _letter
        }
    }


    /// Fix the identifier for the button
    func fixUpIdentifier()
    {
        let rawCharacters = textField.stringValue
        let charactersLeft = rawCharacters.uppercased()
        var nextLetter: Letter?
        var  replacementString = ""

        // Go through all the characters until we find the first one that
        // could be a letter and make that the letter that the key thinks it has.
        // All the characters after that are put back in the text field.
		for character in charactersLeft
        {
            if nextLetter != nil
            {
                replacementString += [ character ]
            }
            else if let candidateLetter = Letter(rawValue: character),
                    candidateLetter != .UpperBound // Could be if they typed a $
            {
                nextLetter = candidateLetter
            }
        }

        if let nextLetter = nextLetter
        {
            self._letter = nextLetter
        }
        else
        {
            self._letter = nil
        }
        textField.stringValue = replacementString
    }
}

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
        super.mouseDown(theEvent)
    }
}

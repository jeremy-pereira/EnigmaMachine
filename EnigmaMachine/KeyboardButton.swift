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
        if let keyboardDelegate = keyboardDelegate
        {
            keyboardDelegate.letterPressed(keyboardButton.letter, keyboard: self)
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

    var letter: Letter
    {
        var idChar = self.identifier![self.identifier!.startIndex]
		return Letter(rawValue: idChar)!
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

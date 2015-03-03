//
//  EnigmaMachine.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public class EnigmaMachine
{
    var rotorCradle: RotorCradle = RotorCradle()
    var plugboard: PlugBoard = PlugBoard()
    public var litLamp: Letter?

    public init()
    {

    }

/**

Insert a rotor in a given slot with the given start position

:param: rotor An instance of the rotr to insert.
:param: inSlot Which slot to put it in numbered from the right starting at 0
:param: position Which letter on the rotor's outer ring is initially displayed.

*/
    public func insertRotor(rotor: Rotor, inSlot slotNumber: Int, position: Letter)
    {
		rotorCradle.slot[slotNumber].insertRotor(rotor, position: position)
    }
    public func insertReflector(reflector: Reflector, position: Letter)
    {
		rotorCradle.insertReflector(reflector, position: position)
    }

    public func plugInPair(pair: (Letter, Letter))
    {
        plugboard.plugInPair(pair)
    }

    public func keyDown(aLetter: Letter)
    {
		if litLamp == nil
        {
            rotorCradle.rotate()
            var currentLetter: Letter?
            currentLetter = plugboard.forward[aLetter]
            if let resultLetter = currentLetter
            {
                currentLetter = rotorCradle.forward[resultLetter]
            }
            if let resultLetter = currentLetter
            {
                currentLetter = plugboard.reverse[resultLetter]
            }
            litLamp = currentLetter
        }
    }

    public func keyUp()
    {
        litLamp = nil
    }

    public var rotorReadOut: [Letter?]
    {
		get
        {
            var ret: [Letter?] = []
            for aSlot in rotorCradle.slot
            {
                ret.append(aSlot.rotorPosition)

            }
            return ret
        }
    }
}
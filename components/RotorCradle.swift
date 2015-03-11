//
//  RotorCradle.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 26/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

/**

Class that models a slot to put a rotor in.

*/
public class RotorSlot: Connector
{
    private var _rotor: Rotor?
    private var _rotorPosition: Letter?

    var pawlEngaged: Bool = false

    public var rotor: Rotor?
    {
        return _rotor
    }

    public var rotorPosition: Letter?
    {
		return _rotorPosition
    }

    public var forward: Connection = nullConnection
    public var reverse: Connection = nullConnection

    init()
    {
        // TODO: This probably causes a reference cycle
        forward = ClosureConnection
        {
            letter in
            var ret: Letter?
			if let rotor = self.rotor
            {
				if let rotorPosition = self.rotorPosition
                {
					ret = letter &+ rotorPosition
                    ret = rotor.forward[ret!]
					if ret != nil
                    {
                        ret = ret! &- rotorPosition
                    }
                }
            }
            return ret
        }
        reverse = ClosureConnection
        {
            letter in
            var ret: Letter?
            if let rotor = self.rotor
            {
                if let rotorPosition = self.rotorPosition
                {
                    ret = letter &+ rotorPosition
                    ret = rotor.reverse[ret!]
                    if ret != nil
                    {
                        ret = ret! &- rotorPosition
                    }
                }
            }
            return ret
        }

    }

/**

Insert a rotor into this slot at the given position.

:param: rotor Rotor to insert.
:param: position Starting position of the rotor.

*/
    public func insertRotor(rotor: Rotor, position: Letter)
    {
        _rotor = rotor
        _rotorPosition = position
    }

    private func rotate()
    {
        if let rotorPosition = _rotorPosition
        {
            _rotorPosition = rotorPosition &+ 1
        }
    }

    var isNotchAligned: Bool
    {
		get
        {
            var ret = false
            if let rotorPosition = rotorPosition
            {
                if let notch = rotor?.notch
                {
					ret = notch == rotorPosition
                }
            }
            return ret
        }
    }

/**

Try to rotate the rotor in the slot by one letter.  This will only work if the
pawl is engaged.

*/
    public func tryToRotate()
    {
        if pawlEngaged
        {
            rotate()
        }
    }

	public func removeRotor() -> Rotor?
    {
        var ret: Rotor? = self.rotor

        _rotor = nil
        _rotorPosition = nil

		return ret
    }
}

/**
Models the rotor cradle i.e. the three rotors, the reflector and the stepping
mechanism.
*/
public class RotorCradle: Connector
{
    public var slot: [RotorSlot] = []
    private var _reflector: Reflector?
    private var _reflectorPosition: Letter?

    public var forward: Connection = nullConnection
    public var reverse: Connection = nullConnection

    public init()
    {
        slot.append(RotorSlot())
        slot.append(RotorSlot())
        slot.append(RotorSlot())
        forward = ClosureConnection
        {
            // TODO: This probably causes a reference cycle
            letter in
            var currentLetter: Letter? = letter
            for var i = 0 ; i < self.slot.count && currentLetter != nil ; ++i
            {
				currentLetter = self.slot[i].forward[currentLetter!]
            }
            if currentLetter != nil
            {
                currentLetter = self.reflect(currentLetter!)
            }
            if currentLetter != nil
            {
                for var i = 0 ; i < self.slot.count && currentLetter != nil ; ++i
                {
                    currentLetter = self.slot[self.slot.count - i - 1].reverse[currentLetter!]
                }

            }
            return currentLetter
        }
        reverse = forward
    }

    func reflect(letter: Letter) -> Letter?
    {
        var ret: Letter?
        if let reflector = _reflector
        {
            if let reflectorPosition = _reflectorPosition
            {
				ret = reflector.forward[letter &+ reflectorPosition]! &- reflectorPosition
            }
        }
        return ret
    }

    /**

    Insert a reflector in the given position.

    :param: refelctor Reflector to insert.
    :param: position position of the reflector.

    */
    public func insertReflector(reflector: Reflector, position: Letter)
    {
        _reflector = reflector
        _reflectorPosition = position
    }


    public func rotate()
    {
        for slotNumber in 0 ..< (slot.count - 1)
        {
            if slot[slotNumber].isNotchAligned
            {
                slot[slotNumber].pawlEngaged = true
                slot[slotNumber + 1].pawlEngaged = true
            }
        }
        slot[0].pawlEngaged = true // First rotor always advances

        for aSlot in slot
        {
			aSlot.tryToRotate()
            aSlot.pawlEngaged = false
        }
    }

}
//
//  RotorCradle.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 26/02/2015.
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

import Toolbox

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

    public var forward: Connection = NullConnection.null
    public var reverse: Connection = NullConnection.null

    init(name: String)
    {
        // TODO: This probably causes a reference cycle
        forward = ClosureConnection(name: name + ".forward")
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
        reverse = ClosureConnection(name: name + ".reverse")
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
    public func insert(rotor: Rotor, position: Letter)
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
        let ret = self.rotor

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

    public var forward: Connection = IdentityConnection.identity
    public var reverse: Connection = IdentityConnection.identity

    public init()
    {
        // This is a three rotor machine at the moment.
        slot.append(RotorSlot(name: "slot 1"))
        slot.append(RotorSlot(name: "slot 2"))
        slot.append(RotorSlot(name: "slot 3"))
        // The two closure connections effectively wire up the cradle. In the
        // forward direction, we go through each slot and then the reflector and
        // back again. The reverse direction is the same as the forward direction.
        forward = ClosureConnection(name: "rotor cradle")
        {
            [unowned self] letter in
            var currentLetter: Letter? = letter

            // Use monad bind to chain functions together
            currentLetter = self.slot.reduce(letter)
            {
                (currentLetter, slot) -> Letter? in
                guard let aLetter = currentLetter else { return nil }
                return slot.forward[aLetter]
            }
            >>-
            { self.reflect(letter: $0) }
            >>-
            {
                self.slot.reversed().reduce($0)
                {
                    (currentLetter, slot) -> Letter? in
                    guard let aLetter = currentLetter else { return nil }
                    return slot.reverse[aLetter]
                }
            }

            return currentLetter
        }
        reverse = forward
    }

    func reflect(letter: Letter) -> Letter?
    {
        var ret: Letter?
        if let reflector = _reflector, let reflectorPosition = _reflectorPosition
        {
            ret = reflector.forward[letter &+ reflectorPosition]! &- reflectorPosition
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

//
//  EnigmaMachine.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
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

import Foundation


public protocol EnigmaObserver: AnyObject
{
    func stateChanged(machine: EnigmaMachine)
}

public class EnigmaMachine
{

    private class Observer
    {
        weak var observer: EnigmaObserver?
        init(observer: EnigmaObserver)
        {
            self.observer = observer
        }
    }

    var rotorCradle: RotorCradle = RotorCradle()
    var plugboard: PlugBoard = PlugBoard()
    public var litLamp: Letter?


    private var observers: [Observer] = []

    public init()
    {

    }

/**

Insert a rotor in a given slot with the given start position

:param: rotor An instance of the rotr to insert.
:param: inSlot Which slot to put it in numbered from the right starting at 0
:param: position Which letter on the rotor's outer ring is initially displayed.

*/
    public func insert(rotor: Rotor, inSlot slotNumber: Int, position: Letter)
    {
        rotorCradle.slot[slotNumber].insert(rotor: rotor, position: position)
        notifyStateChange()
    }

    public func removeRotorFromSlot(slotNumber: Int) -> Rotor?
    {
        let ret = rotorCradle.slot[slotNumber].removeRotor()
        notifyStateChange()
        return ret
    }

    public func setRotorPosition(newPosition: Letter, slotNumber: Int)
    {
        if let rotor = self.removeRotorFromSlot(slotNumber: slotNumber)
        {
            self.insert(rotor: rotor, inSlot: slotNumber, position: newPosition)
        }
    }

    public func insert(reflector: Reflector, position: Letter)
    {
        rotorCradle.insertReflector(reflector: reflector, position: position)
        notifyStateChange()
    }

    public func plugIn(pair: (Letter, Letter))
    {
        plugboard.plugIn(pair: pair)
        notifyStateChange()
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
            notifyStateChange()
        }
    }

    public func keyUp()
    {
        if litLamp != nil
        {
            litLamp = nil
			notifyStateChange()
        }
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

    public func rotorPositionForSlot(slotNumber: Int) -> Letter?
    {
        var ret: Letter?

        if slotNumber >= 0 && slotNumber < self.rotorCradle.slot.count
        {

			ret = self.rotorCradle.slot[slotNumber].rotorPosition
        }
        return ret
    }

/**

Classes that are interested in state changes of the enigma machine use this
function to register themselves.  Only a `weak` reference is held.

:param: anObserver The new observer

*/
    public func register(observer: EnigmaObserver)
    {
		observers.append(Observer(observer: observer))
    }

    private func notifyStateChange()
    {
        for observer in observers.filter({ observer in observer.observer != nil}).map({ $0.observer! })
        {
            observer.stateChanged(machine: self)
        }
    }
}

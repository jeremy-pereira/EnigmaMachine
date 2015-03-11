//
//  EnigmaMachine.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

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
    public func insertRotor(rotor: Rotor, inSlot slotNumber: Int, position: Letter)
    {
		rotorCradle.slot[slotNumber].insertRotor(rotor, position: position)
        notifyStateChange()
    }

    public func removeRotorFromSlot(slotNumber: Int) -> Rotor?
    {
        let ret = rotorCradle.slot[slotNumber].removeRotor()
        notifyStateChange()
        return ret
    }

    public func insertReflector(reflector: Reflector, position: Letter)
    {
		rotorCradle.insertReflector(reflector, position: position)
        notifyStateChange()
    }

    public func plugInPair(pair: (Letter, Letter))
    {
        plugboard.plugInPair(pair)
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

/**

Classes that are interested in state changes of the enigma machine use this
function to register themselves.  Only a `weak` reference is held.

:param: anObserver The new observer

*/
    public func registerObserver(anObserver: EnigmaObserver)
    {
		observers.append(Observer(observer: anObserver))
    }

    private func notifyStateChange()
    {
        var actualObservers = observers.filter{ observer in observer.observer != nil}.map{ $0.observer! }
        for observer in actualObservers
        {
            observer.stateChanged(self)
        }
    }
}
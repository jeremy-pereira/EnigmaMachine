//
//  SpareRotorBox.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 09/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

/**

A box of rotors that can be used in an enigma machine.

*/
public class SpareRotorBox
{
    var rotor: [Rotor] = [ RotorI(), RotorII(), RotorIII(), RotorIV(), RotorV()]

    public init()
    {

    }

/**

Put a rotor in the box.

:param: newRotor Rotor to put in the box.

*/
    public func add(newRotor: Rotor)
    {
		rotor.append(newRotor)
    }

/**

Remove a rotor with the given name from the box and return it to the caller.  If
there are two rotors with the same name, we take the first one only.

:param: name Name of rotor to get.
:returns: The rotor with the given name or nil if there is none in the box.

*/
    public func remove(name: String) -> Rotor?
    {
        var ret: Rotor?

        var foundIndex: Int?
        for var i = 0 ; i < rotor.count && foundIndex == nil ; ++i
        {
			if rotor[i].name == name
            {
                foundIndex = i
            }
        }
        if let foundIndex = foundIndex
        {
            ret = rotor[foundIndex]
            rotor.removeAtIndex(foundIndex)
        }
        return ret
    }

    public var count: Int { return rotor.count }
}
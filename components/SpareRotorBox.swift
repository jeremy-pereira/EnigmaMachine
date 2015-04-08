//
//  SpareRotorBox.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 09/03/2015.
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

/**

A box of rotors that can be used in an enigma machine.

*/
public class SpareRotorBox
{
    var rotor: [Rotor] = [ Rotor.makeMilitaryI(),
        				   Rotor.makeMilitaryII(),
                           Rotor.makeMilitaryIII(),
                           Rotor.makeMilitaryIV(),
                           Rotor.makeMilitaryV() ]

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
    public func removeRotor(#name: String) -> Rotor?
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
    public func removeRotor(rotorToGo: Rotor) -> Rotor?
    {
        var ret: Rotor?

        var foundIndex: Int?
        for var i = 0 ; i < rotor.count && foundIndex == nil ; ++i
        {
            if rotor[i] === rotorToGo
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
    public func removeRotor(#index: Int) -> Rotor?
    {
        var ret: Rotor?

        if index >= 0 && index < rotor.count
        {
            ret = rotor[index]
            rotor.removeAtIndex(index)
        }
        return ret
    }

    public var count: Int { return rotor.count }

    public func rotor(index: Int) -> Rotor?
    {
        var ret: Rotor?
		if index >= 0 && index < rotor.count
        {
			ret = rotor[index]
        }
        return ret
    }

    public func rotorsAtIndexes(indexes: NSIndexSet) -> [Rotor]
    {
        var ret: [Rotor] = []
        for (index, rotor) in enumerate(self.rotor)
        {
			if indexes.containsIndex(index)
            {
                ret.append(rotor)
            }
        }
        return ret
    }
}
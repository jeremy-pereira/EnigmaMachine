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

    /// Remove a rotor with the given name from the box and return it to the caller.  If
    /// there are two rotors with the same name, we take the first one only.
    ///
    /// - Parameter name: Name of the rotor to remove
    /// - Returns: The rotor to remove or nil if it is not installed.
    public func removeRotor(name: String) -> Rotor?
    {
        var ret: Rotor?
        if let foundIndex = rotor.index(where: { $0.name == name })
        {
            ret = rotor.remove(at: foundIndex)
        }
        return ret
    }


    /// Remove a specific rotor and return it.
    ///
    /// - Parameter rotorToGo: The rotor to remove.
    /// - Returns: The removed rotor.
    public func remove(rotor rotorToGo: Rotor) -> Rotor?
    {
        var ret: Rotor?
        if let foundIndex = rotor.index(where: { $0 === rotorToGo })
        {
            ret = rotor.remove(at: foundIndex)
        }
        return ret
    }


    /// Remove the rotr at a given index. If the index is out of bounds, nil is
    /// returned.
    ///
    /// - Parameter index: The index of the rotor to go
    /// - Returns: The removed rotor.
    public func removeRotor(index: Int) -> Rotor?
    {
        var ret: Rotor?

        if index >= 0 && index < rotor.count
        {
            ret = rotor.remove(at: index)
        }
        return ret
    }

    public var count: Int { return rotor.count }

    public func rotor(_ index: Int) -> Rotor?
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
        for (index, rotor) in rotor.enumerated()
        {
			if indexes.contains(index)
            {
                ret.append(rotor)
            }
        }
        return ret
    }
}

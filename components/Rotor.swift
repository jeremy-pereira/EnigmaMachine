//
//  Rotor.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
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
import Toolbox

public let wiringI   = Wiring(string: "EKMFLGDQVZNTOWYHXUSPAIBRCJ")
public let wiringII  = Wiring(string: "AJDKSIRUXBLHWTMCQGZNPYFVOE")
public let wiringIII = Wiring(string: "BDFHJLCPRTXVZNYEIWGAKMUSQO")
public let wiringIV = Wiring(string: "ESOVPZJAYQUIRHXLNFTGKDCMWB")
public let wiringV = Wiring(string: "VZBRGITYUPSDNHLXAWMJQOFECK")

public let wiringReflectorB = Wiring(string: "YRUHQSLDPXNGOKMIEBFZCWVJAT")

/// Class representing an Enigma rotor
public class Rotor: Connector
{
    public var name: String
    var wiring: Wiring
    var notch: Letter
    public var forward: Connection
    public var reverse: Connection
/**

The ring stellung for the rotor.  This is the offset of the wiring to the outer
ring.  For new rotors defaults to A

*/
    public var ringStellung: Letter = Letter.A

    init(name: String, wiring: Wiring, notch: Letter)
    {
        self.name = name
        self.wiring = wiring
        self.notch = notch
        let rToL = RotorConnection(isRightToLeft: true)
        let lToR = RotorConnection(isRightToLeft: false)
        self.reverse = lToR
        self.forward = rToL
        rToL.rotor = self
        lToR.rotor = self
    }

    var description: String { return "EnigmaMachine.\(name) rs \(ringStellung)" }

    public class func makeMilitaryI() -> Rotor
    {
        return Rotor(name: "I", wiring: wiringI, notch: Letter.Q)
    }

    public class func makeMilitaryII() -> Rotor
    {
        return Rotor(name: "II", wiring: wiringII, notch: Letter.E)
    }

    public class func makeMilitaryIII() -> Rotor
    {
        return Rotor(name: "III", wiring: wiringIII, notch: Letter.V)
    }

    public class func makeMilitaryIV() -> Rotor
    {
        return Rotor(name: "IV", wiring: wiringIV, notch: Letter.J)
    }

    public class func makeMilitaryV() -> Rotor
    {
        return Rotor(name: "V", wiring: wiringV, notch: Letter.Z)
    }
}

class RotorConnection: Connection
{
    weak var rotor: Rotor?
    var isRightToLeft: Bool

    init(isRightToLeft: Bool)
    {
        self.isRightToLeft = isRightToLeft
    }

    func map(_ input: Letter) -> Letter?
    {
		return isRightToLeft ? (rotor!.wiring.forward[input &+ rotor!.ringStellung]! &- rotor!.ringStellung)
							 : (rotor!.wiring.reverse[input &+ rotor!.ringStellung]! &- rotor!.ringStellung)
    }

    func makeInverse() -> Connection?
    {
        fatalError("Cannot invoke makeInverse in RotorConnection")
    }

    var connectionString: String
    {
		return rotor!.wiring.connectionString
    }
}


/// Object that models a reflector disc
public class Reflector: Connector
{
    public var forward: Connection = nullConnection
    public var reverse: Connection = nullConnection
    public var wiring: Wiring

    init(wiring: Wiring)
    {
        if !wiring.isReciprocal || wiring.hasStraightThrough
        {
            fatalError("Invalid wiring for a reflector")
        }
        self.wiring = wiring
        forward = ClosureConnection
        {
			letter in
            return self.wiring.forward[letter]
        }
        reverse = forward
    }
}

public let reflectorB = Reflector(wiring: wiringReflectorB)

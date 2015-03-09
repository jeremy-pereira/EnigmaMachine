//
//  Rotor.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public let wiringI   = Wiring(string: "EKMFLGDQVZNTOWYHXUSPAIBRCJ")
public let wiringII  = Wiring(string: "AJDKSIRUXBLHWTMCQGZNPYFVOE")
public let wiringIII = Wiring(string: "BDFHJLCPRTXVZNYEIWGAKMUSQO")
public let wiringIV = Wiring(string: "ESOVPZJAYQUIRHXLNFTGKDCMWB")
public let wiringV = Wiring(string: "VZBRGITYUPSDNHLXAWMJQOFECK")

public let wiringReflectorB = Wiring(string: "YRUHQSLDPXNGOKMIEBFZCWVJAT")

/**

Class representing an Enigma rotor

*/
public class Rotor: Connector
{
    public var name: String
    var wiring: Wiring = Wiring.identity
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
}

class RotorConnection: Connection
{
    weak var rotor: Rotor?
    var isRightToLeft: Bool

    init(isRightToLeft: Bool)
    {
        self.isRightToLeft = isRightToLeft
    }

    subscript(input: Letter) -> Letter?
    {
		return isRightToLeft ? (rotor!.wiring.forward[input &+ rotor!.ringStellung]! &- rotor!.ringStellung)
							 : (rotor!.wiring.reverse[input &+ rotor!.ringStellung]! &- rotor!.ringStellung)
    }

    func makeInverse() -> Connection?
    {
        fatalError("Cannot invoke makeInverse in RotorConnection")
    }
}

/**

German military rotor I

*/
public class RotorI: Rotor
{
    public init()
    {
        super.init(name: "I", wiring: wiringI, notch: Letter.Q)
    }
}

/**

German military rotor II

*/
public class RotorII: Rotor
{
    public init()
    {
        super.init(name: "II", wiring: wiringII, notch: Letter.E)
    }
}

/**

German military rotor III

*/
public class RotorIII: Rotor
{
    public init()
    {
        super.init(name: "III", wiring: wiringIII, notch: Letter.V)
    }
}

/**

German military rotor IV

*/
public class RotorIV: Rotor
{
    public init()
    {
        super.init(name: "IV", wiring: wiringIV, notch: Letter.J)
    }
}

/**

German military rotor V

*/
public class RotorV: Rotor
{
    public init()
    {
        super.init(name: "V", wiring: wiringV, notch: Letter.Z)
    }
}

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
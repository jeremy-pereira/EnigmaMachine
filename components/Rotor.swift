//
//  Rotor.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

let wiringI = Wiring(string: "EKMFLGDQVZNTOWYHXUSPAIBRCJ")

/**

Class representing an Enigma rotor

*/
public class Rotor
{

    var wiring: Wiring = Wiring.identity
    var notch: Letter
/**
	The connection going right to left through the rotor.
*/
    public var rightToLeft: Connection
/**
    The connection going left to right through the rotor.
*/
    public var leftToRight: Connection
/**

The ring stellung for the rotor.  This is the offset of the wiring to the outer
ring.  For new rotors defaults to A

*/
    public var ringStellung: Letter = Letter.A

    init(wiring: Wiring, notch: Letter)
    {
        self.wiring = wiring
        self.notch = notch
        let rToL = RotorConnection(isRightToLeft: true)
        let lToR = RotorConnection(isRightToLeft: false)
        self.leftToRight = lToR
        self.rightToLeft = rToL
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

    subscript(input: Letter) -> Letter
    {
		return isRightToLeft ? (rotor!.wiring[input &+ rotor!.ringStellung] &- rotor!.ringStellung)
							 : (rotor!.wiring.inverse[input &+ rotor!.ringStellung] &- rotor!.ringStellung)
    }

    var internalInverse: Connection?

    var inverse: Connection
    {
		get
        {
			if internalInverse == nil
            {
                let iv =  RotorConnection(isRightToLeft: !self.isRightToLeft)
                internalInverse = iv
                iv.internalInverse = self
            }
            return internalInverse!
        }
    }
}

/**

German military rotor I

*/
public class RotorI: Rotor
{
    public init()
    {
        super.init(wiring: wiringI, notch: Letter.Q)
    }
}
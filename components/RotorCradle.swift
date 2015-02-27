//
//  RotorCradle.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 26/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public class RotorSlot: Connector
{
    public var rotor: Rotor?

    public var forward: Connection
    public var reverse: Connection

    init()
    {
        forward = ClosureConnection(mappingFunc: { letter in return nil })
        reverse = ClosureConnection(mappingFunc: { letter in return nil })
    }
}

public class RotorCradle: Connector
{
    public var slot: [RotorSlot] = []

    public var forward: Connection
    public var reverse: Connection

    public init()
    {
        slot.append(RotorSlot())
        slot.append(RotorSlot())
        slot.append(RotorSlot())
        forward = ClosureConnection(mappingFunc: { letter in return nil })
        reverse = ClosureConnection(mappingFunc: { letter in return nil })
    }
}
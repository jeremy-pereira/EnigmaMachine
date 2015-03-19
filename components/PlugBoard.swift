//
//  PlugBoard.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 02/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

/**

A class that models a plugboard

*/
public class PlugBoard: Connector
{
    public var forward: Connection = nullConnection
    public var reverse: Connection = nullConnection

    private var map: [Letter : Letter] = [:]

    public init()
    {
		forward = ClosureConnection
        {
            // TODO: Probably a reference cycle on self
			letter in
            var ret = letter
            if let result = self.map[letter]
            {
                ret = result
            }
            return ret
        }
        reverse = forward
    }

/**

Plug in a wire between two letters.  This creates a reciprocal swap between the
letters in question.  If either letter in the pair is already plugged in, it is
unplugged.

:param: pair The pair of letters to plug in.

*/
    public func plugInPair(pair: (Letter, Letter))
    {
		if map[pair.0] != nil
        {
            unplug(pair.0)
        }
        if map[pair.1] != nil
        {
            unplug(pair.1)
        }
        map[pair.0] = pair.1
        map[pair.1] = pair.0
    }

    func unplug(aLetter: Letter)
    {
        if let otherEnd = map[aLetter]
        {
			map.removeValueForKey(aLetter)
            map.removeValueForKey(otherEnd)
        }
    }

    public func letterConnectedTo(#letter: Letter) -> Letter?
    {
        return map[letter]
    }
}
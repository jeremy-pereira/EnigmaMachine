//
//  PlugBoard.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 02/03/2015.
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

A class that models a plugboard

*/
public class PlugBoard: Connector
{
    public var forward: Connection = NullConnection.null
    public var reverse: Connection = NullConnection.null

    private var map: [Letter : Letter] = [:]

    public init()
    {
		forward = ClosureConnection(name: "plugboard")
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
    public func plugIn(pair: (Letter, Letter))
    {
		if map[pair.0] != nil
        {
            unplug(aLetter: pair.0)
        }
        if map[pair.1] != nil
        {
            unplug(aLetter: pair.1)
        }
        if pair.0 != pair.1
        {
            map[pair.0] = pair.1
            map[pair.1] = pair.0
        }
    }

    func unplug(aLetter: Letter)
    {
        if let otherEnd = map[aLetter]
        {
            map.removeValue(forKey: aLetter)
            map.removeValue(forKey: otherEnd)
        }
    }

    public func letterConnectedTo(letter: Letter) -> Letter?
    {
        return map[letter]
    }
}

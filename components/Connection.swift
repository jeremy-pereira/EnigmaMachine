//
//  Connection.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015, 2018 Jeremy Pereira. All rights reserved.
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

private let log = Logger.getLogger("EnigmaMachine.Components.Connection")

/**

Enumeration of all the letters that Enigma can deal with

*/
public enum Letter: Character, Comparable, CustomStringConvertible
{
	case A = "A", B = "B", C = "C", D = "D", E = "E", F = "F", G = "G", H = "H",
         I = "I", J = "J", K = "K", L = "L", M = "M", N = "N", O = "O", P = "P",
    	 Q = "Q", R = "R", S = "S", T = "T", U = "U", V = "V", W = "W", X = "X",
    	 Y = "Y", Z = "Z", UpperBound = "$"

/**
    
The ordinal of the letter.  A is assumed to have ordinal 0 and Z ordinal 25.

*/
    public var ordinal: Int
    {
        get
        {
            var ret: Int
            switch self
            {
            case .A:
                ret = 0
            case .B:
                ret = 1
            case .C:
                ret = 2
            case .D:
                ret = 3
            case .E:
                ret = 4
            case .F:
                ret = 5
            case .G:
                ret = 6
            case .H:
                ret = 7
            case .I:
                ret = 8
            case .J:
                ret = 9
            case .K:
                ret = 10
            case .L:
                ret = 11
            case .M:
                ret = 12
            case .N:
                ret = 13
            case .O:
                ret = 14
            case .P:
                ret = 15
            case .Q:
                ret = 16
            case .R:
                ret = 17
            case .S:
                ret = 18
            case .T:
                ret = 19
            case .U:
                ret = 20
            case .V:
                ret = 21
            case .W:
                ret = 22
            case .X:
                ret = 23
            case .Y:
                ret = 24
            case .Z:
                ret = 25
            case .UpperBound:
                ret = Int.max
            }
            return ret
        }
    }
/**
    
Get the letter for a particular ordinal.  Ordinals < 0 and > 25 are treated as 
if they are modulo 26.
    
:param: ordinal The ordinal to translate into a letter.
:returns: The letter for the given ordinal.

*/
    public static func letter(ordinal: Int) -> Letter
    {
        var ret: Letter
        var normalisedOrdinal = ordinal % 26
        if normalisedOrdinal < 0
        {
            normalisedOrdinal = 26 + normalisedOrdinal
        }
        switch (normalisedOrdinal)
        {
        case 0:
            ret = Letter.A
        case 1:
            ret = Letter.B
        case 2:
            ret = Letter.C
        case 3:
            ret = Letter.D
        case 4:
            ret = Letter.E
        case 5:
            ret = Letter.F
        case 6:
            ret = Letter.G
        case 7:
            ret = Letter.H
        case 8:
            ret = Letter.I
        case 9:
            ret = Letter.J
        case 10:
            ret = Letter.K
        case 11:
            ret = Letter.L
        case 12:
            ret = Letter.M
        case 13:
            ret = Letter.N
        case 14:
            ret = Letter.O
        case 15:
            ret = Letter.P
        case 16:
            ret = Letter.Q
        case 17:
            ret = Letter.R
        case 18:
            ret = Letter.S
        case 19:
            ret = Letter.T
        case 20:
            ret = Letter.U
        case 21:
            ret = Letter.V
        case 22:
            ret = Letter.W
        case 23:
            ret = Letter.X
        case 24:
            ret = Letter.Y
        case 25:
            ret = Letter.Z
        default:
            fatalError("Something % 26 is not in the range 0 ..< 26")
        }
        return ret
    }

    public func successor() -> Letter
    {
        return self == Letter.Z ? Letter.UpperBound
        						: Letter.letter(ordinal: self.ordinal + 1)
    }

    public var description: String
    {
        get { return "\(self.rawValue)" }
    }
}

extension Letter: Strideable
{
    public func distance(to other: Letter) -> Int
    {
        return other.ordinal - self.ordinal
    }

    public func advanced(by n: Int) -> Letter
    {
        return Letter.letter(ordinal: self.ordinal + n)
    }

    public typealias Stride = Int


}

public func &+(left: Letter, right: Letter) -> Letter
{
    return Letter.letter(ordinal: left.ordinal + right.ordinal)
}

public func &+(left: Letter, right: Int) -> Letter
{
    return Letter.letter(ordinal: left.ordinal + right)
}

public func &-(left: Letter, right: Letter) -> Letter
{
    return Letter.letter(ordinal: left.ordinal - right.ordinal)
}

public func <(left: Letter, right: Letter) -> Bool
{
    return left.ordinal < right.ordinal
}

public func ==(left: Letter, right: Letter) -> Bool
{
    return left.ordinal == right.ordinal
}

/// Protocol defining a connection from a set of 26 input letters to 26 output
/// letters.
public protocol Connection
{
    /// maps an input letter to an output letter.
    ///
    /// - Parameter index: index The input letter
    func map(_ index: Letter) -> Letter?

    /// Creates an inverse connection if it is possible to do so (requires 1:1
    /// letter mapping).
    ///
    /// - Returns: The inverse connection or nil if it couldn't be done.
    func makeInverse() -> Connection?
/**
A string representation of the connections.  It should consist of a 26 character
string.  The character at each index is the mapping for the letter with the 
ordinal of the index.
    
If a connection from a letter returns nil, use - in the string.
*/
    var connectionString: String { get }
}

public extension Connection
{
    subscript(index: Letter) -> Letter?
    {
        get
        {
            let ret = map(index)
            log.debug("\(index) -> \(ret?.description ?? "nil") from \(connectionString)")
            return map(index)
        }
    }
}


/// A connection that is the identity connection. It maps any letter onto
/// itself. There is only one identiy connection.
public struct IdentityConnection: Connection
{
    private init()
    {
    }

    public func map(_ index: Letter) -> Letter?
    {
        return index
    }

    public func makeInverse() -> Connection?
    {
        return self
    }

    public var connectionString: String
    {
        let letterRange = Letter.A ... Letter.Z

        return letterRange.reduce("")
        {
            (result: String, letter: Letter) -> String in
            return result + [letter.rawValue]
        }
    }

    /// The one and only identity connection.
    public static let identity = IdentityConnection()
}

/// Any object that has connections. There's always a forward connection and
/// a reverse connection, A connector is basically a set of wires and you can
/// treverse the wires in either direction.
public protocol Connector
{

    /// The connection in the forward direction
    var forward: Connection { get }
    /// The connection in the reverse direction.
    var reverse: Connection { get }
}

/// A connection that uses a dictionary to map inputs to outputs.
///
/// When you create it supply a dictionary of mappings.  By default each letter is
/// mapped to itself so the map supplied to init need only contain non identity
/// mappings. For example
///
/// ```
/// let conn = DictionaryConnection(map: [ Letter.A : Letter.B ])
/// ```
/// maps every letter to itself except A which it maps to B.
class DictionaryConnection: Connection
{
    var letterMap: [Letter : Letter] = [:]

    init(map: [Letter: Letter])
    {
        for letter in Letter.A ... Letter.Z
        {
			self.letterMap[letter] = letter
        }
        for key in map.keys
        {
            self.letterMap[key] = map[key]
        }
    }

    func map(_ index: Letter) -> Letter?
    {
    	return letterMap[index]
    }

    func makeInverse() -> Connection?
    {
        var newMap: [Letter : Letter] = [:]
        for key in letterMap.keys
        {
            /*
			 *  If there already exists an entry for the inverse key, it means
			 *  two letters map to the same output.  Therefore the inverse 
             *  would be ambiguous.
			 */
            if newMap[letterMap[key]!] != nil
            {
                return nil
            }
			newMap[letterMap[key]!] = key
        }
        return DictionaryConnection(map: newMap)
    }

    lazy var connectionString: String =
    {
        var ret: String = ""
        for letter in Letter.A ... Letter.Z
        {
            if let aMapping = self.letterMap[letter]
            {
                ret.append(aMapping.rawValue)
            }
            else
            {
                ret.append(Character("-"))
            }
        }
        return ret
    }()
}


/// A connection that maps letters based on a passed in function
class ClosureConnection: Connection
{
    /// The mapping function
    var mappingFunc: (Letter) -> Letter?

    init(_ mappingFunc: @escaping (Letter) -> Letter?)
    {
        self.mappingFunc = mappingFunc
    }

    func map(_ letter: Letter) -> Letter?
    {
        return mappingFunc(letter)
    }

    func makeInverse() -> Connection?
    {
        fatalError("Cannot invoke makeInverse in ClosureConnection")
    }

    var connectionString: String
    {
		get
        {
            var ret: String = ""
            for letter in Letter.A ... Letter.Z
            {
                if let aMapping = self[letter]
                {
                    ret.append(aMapping.rawValue)
                }
                else
                {
                    ret.append(Character("-"))
                }
            }
            return ret
        }
    }
}

class NullConnection: ClosureConnection
{
    init()
    {
        super.init({ letter in return nil })
    }
}

public let nullConnection: Connection = NullConnection()

/// A class representing a fixed set of wirings from one letter to another.
public class Wiring: Connector
{
    public var forward: Connection
    public var reverse: Connection

    /// Initialise a wiring from a map of one set of letters to another.
    ///
    /// - Parameter map: The map describing the wiring. Only specifiy letters
    ///                  that do not map to themselves.
    public init(map: [Letter : Letter])
    {
        let forwardMap = DictionaryConnection(map: map)
        forward = forwardMap
        if let reverseMap = forwardMap.makeInverse()
        {
			reverse = reverseMap
        }
        else
        {
            fatalError("Reverse map for wiring would be ambiguous")
        }
    }

    public convenience init(string: String)
    {
        var stringMap: [Letter : Letter] = [:]
        for (input, toChar) in zip(Letter.A ... Letter.Z, string)
        {
            if let toLetter = Letter(rawValue: toChar)
            {
				stringMap[input] = toLetter
            }
            else
            {
                fatalError("Initialising wiring from string: string has invalid character")
            }
        }
        self.init(map: stringMap)
    }

    public lazy var connectionString: String =
    {
		return self.forward.connectionString
    }()

    /**

    A standard straight through connection that maps every letter to itself

	*/
    public static let identity: Wiring = identityWiring


    /// true if the wiring is reciprocal, that is a mapping in the forward
    /// direction followed by a maping backwards yiends the original letter for
    /// all letters.
    public lazy var isReciprocal: Bool = {
        for letter in Letter.A ... Letter.Z
        {
            guard let intermediate = self.forward[letter] else { return false }
            guard self.forward[intermediate] == letter else { return false }
         }
        return true
    }()

    /// true if any of the letters maps to themselves.
    public lazy var hasStraightThrough: Bool = {
        for letter in Letter.A ... Letter.Z
        {
            if let intermediate = self.forward[letter]
            {
                guard intermediate != letter else { return true }
            }
        }
        return false
    }()
}

private let identityWiring = Wiring(map: [:])

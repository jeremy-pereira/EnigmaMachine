//
//  Connection.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation


/**

Enumeration of all the letters that Enigma can deal with

*/
public enum Letter: Character, ForwardIndexType, Comparable, Printable
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
            case A:
                ret = 0
            case B:
                ret = 1
            case C:
                ret = 2
            case D:
                ret = 3
            case E:
                ret = 4
            case F:
                ret = 5
            case G:
                ret = 6
            case H:
                ret = 7
            case I:
                ret = 8
            case J:
                ret = 9
            case K:
                ret = 10
            case L:
                ret = 11
            case M:
                ret = 12
            case N:
                ret = 13
            case O:
                ret = 14
            case P:
                ret = 15
            case Q:
                ret = 16
            case R:
                ret = 17
            case S:
                ret = 18
            case T:
                ret = 19
            case U:
                ret = 20
            case V:
                ret = 21
            case W:
                ret = 22
            case X:
                ret = 23
            case Y:
                ret = 24
            case Z:
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
    public static func letter(#ordinal: Int) -> Letter
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

public func &+(left: Letter, right: Letter) -> Letter
{
    return Letter.letter(ordinal: left.ordinal + right.ordinal)
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

/**
Protocol defining a connection from a set of 26 input letters to 26 output 
letters.
*/
public protocol Connection
{
/**
The subscript is the mapping function from the input letter to the output letter.

:param: index The input letter
:returns: The output letter if a mapping exists.
*/
    subscript(index: Letter) -> Letter? { get }

/**
Creates an inverse connection if it is possible to do so (requires 1:1 letter 
mapping).
    
`connection.inverse[connection[aLetter]] == aLetter`

:returns: The inverse connection or nil if it couldn't be done, e.g. if two 
    inputs map to the same output.
*/
    func makeInverse() -> Connection?
}

/**
Protocol for an object that has connections.  A connector always has forward
and reverse connections.
*/
public protocol Connector
{
    var forward: Connection { get }
    var reverse: Connection { get }
}

/**

A connection that uses a dictionary to map inputs to outputs.  

When you create it supply a dictionary of mappings.  By default each letter is 
mapped to itself so the map supplied to init need only contain non identity 
mappings.

*/
class DictionaryConnection: Connection
{
    var map: [Letter : Letter] = [:]

    init(map: [Letter: Letter])
    {
        for letter in Letter.A ... Letter.Z
        {
			self.map[letter] = letter
        }
        for key in map.keys
        {
            self.map[key] = map[key]
        }
    }

    subscript(index: Letter) -> Letter?
    {
        get
        {
            return map[index]
        }
    }

    func makeInverse() -> Connection?
    {
        var newMap: [Letter : Letter] = [:]
        for key in map.keys
        {
            /*
			 *  If there already exists an entry for the inverse key, it means
			 *  two letters map to the same output.  Therefore the inverse 
             *  would be ambiguous.
			 */
            if newMap[map[key]!] != nil
            {
                return nil
            }
			newMap[map[key]!] = key
        }
        return DictionaryConnection(map: newMap)
    }
}

class ClosureConnection: Connection
{
    var mappingFunc: (Letter) -> Letter?

    init(mappingFunc: (Letter) -> Letter?)
    {
        self.mappingFunc = mappingFunc
    }

    subscript(letter: Letter) -> Letter?
    {
        return mappingFunc(letter)
    }

    func makeInverse() -> Connection?
    {
        fatalError("Cannot invoke makeInverse in ClosureConnection")
    }

}


/**

A class representing a fixed set of wirings from one letter to another.

*/
public class Wiring: Connector
{
    public var forward: Connection
    public var reverse: Connection
/**
    Initialise a wiring.  The map contains letters that don't map to
    themselves.  By default the wiring is the identity map.
*/
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
        var stringIndex = string.startIndex
        for input in Letter.A ... Letter.Z
        {
			let index = input.ordinal
            let toChar = string[stringIndex]
			let toLetter = Letter(rawValue: toChar)
            if let toLetter = toLetter
            {
				stringMap[input] = toLetter
            }
            else
            {
                fatalError("Initialising wiring from string: string has invalid character")
            }
            stringIndex++
        }
        self.init(map: stringMap)
    }

    /**
    
    A standard straight through connection that maps every letter to itself

	*/
    public static let identity: Wiring = identityConnection
}

private let identityConnection = Wiring(map: [:])

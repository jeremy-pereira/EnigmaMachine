//
//  Connection.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation


public enum Letter: Character
{
	case A = "A", B = "B", C = "C", D = "D", E = "E", F = "F", G = "G", H = "H",
         I = "I", J = "J", K = "K", L = "L", M = "M", N = "N", O = "O", P = "P",
    	 Q = "Q", R = "R", S = "S", T = "T", U = "U", V = "V", W = "W", X = "X",
    	 Y = "Y", Z = "Z"

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
            }
            return ret
        }
    }

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
}

protocol Connection
{
    subscript(index: Letter) -> Letter { get }
    var inverse: Connection { get }
}

class Wiring: Connection
{
    private var lookup: [Letter]
    	= [Letter.A, Letter.B, Letter.C, Letter.D, Letter.E, Letter.F, Letter.G,
           Letter.H, Letter.I, Letter.J, Letter.K, Letter.L, Letter.M, Letter.N,
           Letter.O, Letter.P, Letter.Q, Letter.R, Letter.S, Letter.T, Letter.U,
           Letter.V, Letter.W, Letter.X, Letter.Y, Letter.Z]

/**
    Initialise a connection.  The map contains letters that don't map to 
    themselves.  By default the connection is the identity map.
*/
    init(map: [Letter : Letter])
    {
		for key in map.keys
        {
            lookup[key.ordinal] = map[key]!
        }
    }

    init(invert: Wiring)
    {
        var index = 0
		for letter in invert.lookup
        {
            lookup[letter.ordinal] = Letter.letter(ordinal: index)
            index++
        }
    }

    subscript(index: Letter) -> Letter
    {
		return lookup[index.ordinal]
    }

    lazy var inverse: Connection = { return Wiring(invert: self) }()

    static let identity: Connection = identityConnection
}

private let identityConnection = Wiring(map: [:])

//
//  PlugboardView.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 16/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

extension Letter
{
    func drawInRect(rect: NSRect, attributes: [NSObject : AnyObject])
    {
        let letterAsString =  String(self.rawValue)
        let letterSize = letterAsString.sizeWithAttributes(attributes)
        let widthAdjustment = (rect.size.width - letterSize.width) / 2.0
        let heightAdjustment = (rect.size.height - letterSize.height) / 2.0
        let letterOrigin = NSMakePoint(rect.origin.x + widthAdjustment, rect.origin.y + heightAdjustment)
        letterAsString.drawAtPoint(letterOrigin, withAttributes: attributes)
    }
}

private struct PlugPosition: Hashable
{
    let x: CGFloat
    let y: CGFloat

    var hashValue: Int { return self.x.hashValue ^ self.y.hashValue }
}

private func == (first: PlugPosition, second: PlugPosition) -> Bool
{
	return first.x == second.x && first.y == second.y
}

class PlugboardView: NSView
{
    var backgroundColour: NSColor?
    var foregroundColour: NSColor = NSColor.blackColor()
    var drawScaffolding = false

    var socketWidth: CGFloat
    {
		get
        {
            return self.bounds.width / 17.0
        }
    }

    var socketHeightUnit: CGFloat
    {
		return self.bounds.height / 7.0
    }

    var socketHeight: CGFloat
    {
        get
        {
            return 3 * self.socketHeightUnit
        }
    }

    private static let plugToLetter: [PlugPosition : Letter] =
    [
        PlugPosition(x:  0.0, y: 4.0) : Letter.Q,
        PlugPosition(x:  2.0, y: 4.0) : Letter.W,
        PlugPosition(x:  4.0, y: 4.0) : Letter.E,
        PlugPosition(x:  6.0, y: 4.0) : Letter.R,
        PlugPosition(x:  8.0, y: 4.0) : Letter.T,
        PlugPosition(x: 10.0, y: 4.0) : Letter.Z,
        PlugPosition(x: 12.0, y: 4.0) : Letter.U,
        PlugPosition(x: 14.0, y: 4.0) : Letter.I,
        PlugPosition(x: 16.0, y: 4.0) : Letter.O,
        PlugPosition(x:  1.0, y: 2.0) : Letter.A,
        PlugPosition(x:  3.0, y: 2.0) : Letter.S,
        PlugPosition(x:  5.0, y: 2.0) : Letter.D,
        PlugPosition(x:  7.0, y: 2.0) : Letter.F,
        PlugPosition(x:  9.0, y: 2.0) : Letter.G,
        PlugPosition(x: 11.0, y: 2.0) : Letter.H,
        PlugPosition(x: 13.0, y: 2.0) : Letter.J,
        PlugPosition(x: 15.0, y: 2.0) : Letter.K,
        PlugPosition(x:  0.0, y: 0.0) : Letter.P,
        PlugPosition(x:  2.0, y: 0.0) : Letter.Y,
        PlugPosition(x:  4.0, y: 0.0) : Letter.X,
        PlugPosition(x:  6.0, y: 0.0) : Letter.C,
        PlugPosition(x:  8.0, y: 0.0) : Letter.V,
        PlugPosition(x: 10.0, y: 0.0) : Letter.B,
        PlugPosition(x: 12.0, y: 0.0) : Letter.N,
        PlugPosition(x: 14.0, y: 0.0) : Letter.M,
        PlugPosition(x: 16.0, y: 0.0) : Letter.L
    ]

    override func drawRect(dirtyRect: NSRect)
    {
        super.drawRect(dirtyRect)
        if let backgroundColour = backgroundColour
        {
			backgroundColour.set()
            NSBezierPath.fillRect(dirtyRect)
        }
        foregroundColour.set()
        for (position, letter) in PlugboardView.plugToLetter
        {
            drawPlug(position: position, letter: letter)
        }
    }

    private func drawPlug(#position: PlugPosition, letter: Letter)
    {
        /*
		 *  Scaffolding to be removed later
         */
        if drawScaffolding
        {
            NSGraphicsContext.saveGraphicsState()
            NSColor.redColor().set()
            NSBezierPath.strokeRect(rectForPlugPosition(position, third: 2)) // The extent of the letter
            NSColor.greenColor().set()
            NSBezierPath.strokeRect(rectForPlugPosition(position, third: 1)) // The extent of the top socket
            NSColor.blueColor().set()
            NSBezierPath.strokeRect(rectForPlugPosition(position, third: 0)) // The extent of the bottom socket
            NSGraphicsContext.restoreGraphicsState()
        }

        letter.drawInRect(rectForPlugPosition(position, third: 2), attributes: [:])
        drawSocketAt(position, third: 1)
        drawSocketAt(position, third: 0)
    }

    private func drawSocketAt(position: PlugPosition, third: Int)
    {
        var socketRect: NSRect = NSRect()
        var drawArea = rectForPlugPosition(position, third: third)
        if drawArea.size.width > drawArea.size.height
        {
            socketRect.size.width = drawArea.size.height
            socketRect.size.height = drawArea.size.height
            socketRect.origin.x = drawArea.origin.x + (drawArea.size.width - drawArea.size.height) / 2
            socketRect.origin.y = drawArea.origin.y
        }
        else
        {
            socketRect.size.width = drawArea.size.width
            socketRect.size.height = drawArea.size.width
            socketRect.origin.y = drawArea.origin.x + (drawArea.size.height - drawArea.size.width) / 2
            socketRect.origin.x = drawArea.origin.x
        }
        let lineWidth: CGFloat = 2
        let border: CGFloat = 2 * lineWidth
        socketRect.size.width -= border * 2
        socketRect.size.height -= border * 2
		socketRect.origin.x += border
        socketRect.origin.y += border
        var bezierPath = NSBezierPath(ovalInRect: socketRect)
        bezierPath.lineWidth = lineWidth
        bezierPath.stroke()
    }

    private func rectForPlugPosition(plugPosition: PlugPosition, third: Int) -> NSRect
    {
        var ret = NSRect()
        ret.origin.x = plugPosition.x * socketWidth
        ret.origin.y = (plugPosition.y + CGFloat(third)) * socketHeightUnit
        ret.size.width = socketWidth
        ret.size.height = socketHeightUnit
        return ret
    }
    
}

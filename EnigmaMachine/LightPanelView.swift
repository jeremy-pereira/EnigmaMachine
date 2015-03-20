//
//  LightPanelView.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 19/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

class LightPanelView: NSView
{
    var backgroundColour: NSColor?
    {
		didSet(newColour)
        {
            if newColour != backgroundColour
            {
                self.needsDisplay = true
            }
        }
    }
    var foregroundColour: NSColor = NSColor.blackColor()

    override var opaque: Bool { return backgroundColour != nil }

    private static let letterToLight: [ Letter : (CGFloat, CGFloat) ] =
    [
        Letter.Q : ( 0.0, 2.0),
        Letter.W : ( 2.0, 2.0),
        Letter.E : ( 4.0, 2.0),
        Letter.R : ( 6.0, 2.0),
        Letter.T : ( 8.0, 2.0),
        Letter.Z : (10.0, 2.0),
        Letter.U : (12.0, 2.0),
        Letter.I : (14.0, 2.0),
        Letter.O : (16.0, 2.0),
        Letter.A : ( 1.0, 1.0),
        Letter.S : ( 3.0, 1.0),
        Letter.D : ( 5.0, 1.0),
        Letter.F : ( 7.0, 1.0),
        Letter.G : ( 9.0, 1.0),
        Letter.H : (11.0, 1.0),
        Letter.J : (13.0, 1.0),
        Letter.K : (15.0, 1.0),
        Letter.P : ( 0.0, 0.0),
        Letter.Y : ( 2.0, 0.0),
        Letter.X : ( 4.0, 0.0),
        Letter.C : ( 6.0, 0.0),
        Letter.V : ( 8.0, 0.0),
        Letter.B : (10.0, 0.0),
        Letter.N : (12.0, 0.0),
        Letter.M : (14.0, 0.0),
        Letter.L : (16.0, 0.0)
    ]

    let unitsAcross: CGFloat = 17
    let unitsDown: CGFloat = 3

    let lampGap: CGFloat = 8	// Gap between two lamps in points


    var lampWindowDiameter: CGFloat
    {
        let mSize = Letter.M.sizeWithAttributes([:])
        /*
         *  Get the length of the diagonal by approximating a square and
		 *  adding a bit
		 */
		let diameter = max(mSize.width, mSize.height) * 1.6
        return diameter
    }

    override func drawRect(dirtyRect: NSRect)
    {
        println("Drawing")

        if let backgroundColour = backgroundColour
        {
            println("Filling background")
            backgroundColour.set()
            NSBezierPath.fillRect(dirtyRect)
        }
        let mSize = Letter.M.sizeWithAttributes([:])
        for (letter, position) in LightPanelView.letterToLight
        {
			var circleRect = rectForLamp(position)
            var path = NSBezierPath(ovalInRect: circleRect)
            foregroundColour.setFill()
            NSColor.grayColor().setStroke()
            path.lineWidth = 2
            path.fill()
            path.stroke()
            var fontColour : NSColor = NSColor.grayColor()
            if let backgroundColour = backgroundColour
            {
                fontColour = backgroundColour
            }
            letter.drawInRect(circleRect, attributes: [ NSForegroundColorAttributeName : fontColour])
        }
        println("Drawing end")
    }

    func rectForLamp(centrePosition: (CGFloat, CGFloat)) -> NSRect
    {
        var ret = NSRect()
        let (px, py) = centrePosition

		let viewRect = self.bounds
		let vUnit = lampGap + lampWindowDiameter
        let hUnit = vUnit / 2

        /*
		 *  Calculate x position of rectangle.  
         *  TODO: might need to adjust for the centre and gap
		 */
        let totalLampWidth = hUnit * unitsAcross
        ret.origin.x = viewRect.origin.x + (viewRect.size.width - totalLampWidth) / 2 + px * hUnit
		/*
		 *  Calculate the y position
		 */
        let totalLampHeight = vUnit * unitsDown
        ret.origin.y = viewRect.origin.y + (viewRect.size.height - totalLampHeight) / 2 + py * vUnit

        ret.size.width = lampWindowDiameter
        ret.size.height = lampWindowDiameter

        return ret
    }
    
}

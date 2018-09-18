//
//  LightPanelView.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 19/03/2015.
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
    var foregroundColour: NSColor = NSColor.black

    override var isOpaque: Bool { return backgroundColour != nil }

    var litLetter: Letter?
    {
		didSet(oldValue)
        {
            if let oldValue = oldValue
            {
                let oldPosition = LightPanelView.letterToLight[oldValue]!
                let dirtyRect = rectForLamp(centrePosition: oldPosition)
                self.setNeedsDisplay(dirtyRect)
            }
            if let newValue = litLetter
            {
                let newPosition = LightPanelView.letterToLight[newValue]!
                let dirtyRect = rectForLamp(centrePosition: newPosition)
                self.setNeedsDisplay(dirtyRect)
            }
        }
    }

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
        let mSize = Letter.M.sizeWithAttributes(attributes: [:])
        /*
         *  Get the length of the diagonal by approximating a square and
		 *  adding a bit
		 */
		let diameter = max(mSize.width, mSize.height) * 1.6
        return diameter
    }

    override func draw(_ dirtyRect: NSRect)
    {
        if let backgroundColour = backgroundColour
        {
            backgroundColour.set()
            NSBezierPath.fill(dirtyRect)
        }
        for (letter, position) in LightPanelView.letterToLight
        {
            let circleRect = rectForLamp(centrePosition: position)
            if circleRect.overlaps(otherRect: dirtyRect)
            {
                var fillColour = NSColor.black
                var letterColour = NSColor.white
                if letter == litLetter
                {
                    fillColour = NSColor.yellow
                    letterColour = NSColor.black
                }
                let path = NSBezierPath(ovalIn: circleRect)
                fillColour.setFill()
                NSColor.gray.setStroke()
                path.lineWidth = 2
                path.fill()
                path.stroke()
                letter.drawInRect(rect: circleRect, attributes: [ NSAttributedString.Key.foregroundColor : letterColour])
            }
        }
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

//
//  PlugboardView.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 16/03/2015.
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

protocol PlugboardViewDataSource
{
    func connectLetterPair(letterPair: (Letter, Letter), plugboardView: PlugboardView)
    func connectionForLetter(letter: Letter, plugboardView: PlugboardView) -> Letter?
}

extension Letter
{
    func sizeWithAttributes(attributes: [ NSAttributedString.Key : Any ]) -> NSSize
    {
        return String(self.rawValue).size(withAttributes: attributes)
    }

    func drawInRect(rect: NSRect, attributes: [NSAttributedString.Key : Any])
    {
        let letterAsString =  String(self.rawValue)
        let letterSize = self.sizeWithAttributes(attributes: attributes)
        let widthAdjustment = (rect.size.width - letterSize.width) / 2.0
        let heightAdjustment = (rect.size.height - letterSize.height) / 2.0
        let letterOrigin = NSMakePoint(rect.origin.x + widthAdjustment, rect.origin.y + heightAdjustment)
        letterAsString.draw(at: letterOrigin, withAttributes: attributes)
    }
}

extension NSRect
{
    func overlaps(otherRect : NSRect) -> Bool
    {
        var ret: Bool = false

        ret =  self.origin.x <= otherRect.origin.x + otherRect.size.width
    		&& otherRect.origin.x <= self.origin.x + self.size.width
            && self.origin.y <= otherRect.origin.y + otherRect.size.height
            && otherRect.origin.y <= self.origin.y + self.size.height

        return ret
    }
}

private struct PlugPosition: Hashable, CustomStringConvertible
{
    let x: CGFloat
    let y: CGFloat

    var hashValue: Int { return self.x.hashValue ^ self.y.hashValue }

    var description: String
    {
        get { return "PlugPosition(x: \(x), y: \(y))" }
    }
}

private func == (first: PlugPosition, second: PlugPosition) -> Bool
{
	return first.x == second.x && first.y == second.y
}

class PlugboardView: NSView
{
    var dataSource: PlugboardViewDataSource?

    var backgroundColour: NSColor?
    var foregroundColour: NSColor = NSColor.black
    var drawScaffolding = false
    override var isOpaque: Bool { return backgroundColour != nil }

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

    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        if let backgroundColour = backgroundColour
        {
			backgroundColour.set()
            NSBezierPath.fill(dirtyRect)
        }
        foregroundColour.set()
        for (position, letter) in PlugboardView.plugToLetter
        {
            if rectForPlugPosition(plugPosition: position).overlaps(otherRect: dirtyRect)
            {
                drawPlug(position: position, letter: letter)
            }
        }
        drawDraggingLine()
    }

    private func drawPlug(position: PlugPosition, letter: Letter)
    {
        /*
		 *  Scaffolding to be removed later
         */
        if drawScaffolding
        {
            NSGraphicsContext.saveGraphicsState()
            NSColor.red.set()
            NSBezierPath.stroke(rect(forPlugPosition: position, third: 2)) // The extent of the letter
            NSColor.green.set()
            NSBezierPath.stroke(rect(forPlugPosition: position, third: 1)) // The extent of the top socket
            NSColor.blue.set()
            NSBezierPath.stroke(rect(forPlugPosition: position, third: 0)) // The extent of the bottom socket
            NSGraphicsContext.restoreGraphicsState()
        }

        letter.drawInRect(rect: rect(forPlugPosition: position, third: 2), attributes: [:])
        var connectedLetter: Letter?
        if let dataSource = dataSource
        {
            connectedLetter = dataSource.connectionForLetter(letter: letter, plugboardView: self)
        }
        if let connectedLetter = connectedLetter
        {
            drawPluggedInSocketAt(position: position, letter: connectedLetter)
        }
        else
        {
            drawSocketAt(position: position, third: 1)
            drawSocketAt(position: position, third: 0)
        }
        if position == sourcePosition || position == draggingPosition
        {
            drawSelectedSocket(position: position)
        }
    }

    private func drawDraggingLine()
    {
        if let sourcePosition = sourcePosition, let endPoint = dragEndPoint
        {
            NSGraphicsContext.saveGraphicsState()
            NSColor.blue.set()
            let startPoint = cablePointFor(position: sourcePosition)
            let path = NSBezierPath()
            path.lineWidth = 2.0
            path.move(to: startPoint)
            path.line(to: endPoint)
            path.stroke()
            NSGraphicsContext.restoreGraphicsState()
        }
    }

    private func cablePointFor(position: PlugPosition) -> NSPoint
    {
		var ret = NSPoint()
        let positionRect = rectForSockets(plugPosition: position)
        ret = positionRect.origin
        ret.x += positionRect.size.width / 2.0
        return ret
    }

    let socketLineWidth: CGFloat = 2
    var socketDiameter: CGFloat
    {
		get
        {
            return min(socketWidth, socketHeightUnit) - 4.0 * socketLineWidth
        }
    }

    private func drawSelectedSocket(position: PlugPosition)
    {
        NSGraphicsContext.saveGraphicsState()

        var selectColour = NSColor.blue
        selectColour.set()
        let drawArea = rectForSockets(plugPosition: position)
        var selectedRect = NSRect()
        selectedRect.size.width = socketDiameter + 4.0
        selectedRect.size.height = socketHeightUnit + socketDiameter + 4.0
        selectedRect.origin.x = drawArea.origin.x + drawArea.size.width / 2 - selectedRect.size.width / 2
        selectedRect.origin.y = drawArea.origin.y + drawArea.size.height / 2 - selectedRect.size.height / 2

        let path = NSBezierPath()
        path.lineWidth = socketLineWidth
        path.appendRoundedRect(selectedRect, xRadius: selectedRect.size.width / 2, yRadius: selectedRect.size.width / 2)
        path.stroke()
        selectColour = NSColor(hue: selectColour.hueComponent,
            			saturation: selectColour.saturationComponent,
            			brightness: selectColour.brightnessComponent,
            				 alpha: 0.3)
        selectColour.set()
        path.fill()

        NSGraphicsContext.restoreGraphicsState()
    }

    private var pluggedInSockets: [PlugPosition] = []

    private func drawPluggedInSocketAt(position: PlugPosition, letter: Letter)
    {
        NSGraphicsContext.saveGraphicsState()

        let selectColour = self.foregroundColour
        selectColour.set()
        let drawArea = rectForSockets(plugPosition: position)
        var selectedRect = NSRect()
        selectedRect.size.width = socketDiameter + 4.0
        selectedRect.size.height = socketHeightUnit + socketDiameter + 4.0
        selectedRect.origin.x = drawArea.origin.x + drawArea.size.width / 2 - selectedRect.size.width / 2
        selectedRect.origin.y = drawArea.origin.y + drawArea.size.height / 2 - selectedRect.size.height / 2

        let path = NSBezierPath()
        path.lineWidth = socketLineWidth
        path.appendRoundedRect(selectedRect, xRadius: selectedRect.size.width / 2, yRadius: selectedRect.size.width / 2)
        path.stroke()
        path.fill()
        var letterColour = NSColor.gray
        if let backgroundColour = backgroundColour
        {
			letterColour = backgroundColour
        }
        letterColour.set()
        letter.drawInRect(rect: drawArea, attributes: [NSAttributedString.Key.foregroundColor : letterColour])

        NSGraphicsContext.restoreGraphicsState()

        pluggedInSockets.append(position)
    }

    private func drawSocketAt(position: PlugPosition, third: Int)
    {
        var socketRect: NSRect = NSRect()
        let drawArea = rect(forPlugPosition: position, third: third)
        socketRect.size.width = socketDiameter
        socketRect.size.height = socketDiameter
        socketRect.origin.x = drawArea.origin.x + (drawArea.size.width - socketDiameter) / 2
        socketRect.origin.y = drawArea.origin.y + (drawArea.size.height - socketDiameter) / 2
        let bezierPath = NSBezierPath(ovalIn: socketRect)
        bezierPath.lineWidth = socketLineWidth
        bezierPath.stroke()
    }

    private func rectForPlugPosition(plugPosition: PlugPosition) -> NSRect
    {
        var ret = NSRect()
        ret.origin.x = plugPosition.x * socketWidth
        ret.origin.y = plugPosition.y * socketHeightUnit
        ret.size.width = socketWidth
        ret.size.height = socketHeight
        return ret
    }

    private func rect(forPlugPosition plugPosition: PlugPosition, third: Int) -> NSRect
    {
        var ret = NSRect()
        ret.origin.x = plugPosition.x * socketWidth
        ret.origin.y = (plugPosition.y + CGFloat(third)) * socketHeightUnit
        ret.size.width = socketWidth
        ret.size.height = socketHeightUnit
        return ret
    }

    private func rectForSockets(plugPosition: PlugPosition) -> NSRect
    {
        var ret = NSRect()
        ret.origin.x = plugPosition.x * socketWidth
        ret.origin.y = plugPosition.y * socketHeightUnit
        ret.size.width = socketWidth
        ret.size.height = socketHeightUnit * 2
        return ret
    }

    // MARK: Handle clicking and dragging to create connections

    private var sourcePosition: PlugPosition?
    {
        willSet(newPosition)
        {
            if newPosition != sourcePosition
            {
                dragEndPoint = nil
            }
        }
		didSet(oldSource)
        {
            calculatePositionNeedsDisplay(old: oldSource, new: sourcePosition)
        }
    }
    private var draggingPosition: PlugPosition?
    {
        didSet(oldDragging)
        {
            calculatePositionNeedsDisplay(old: oldDragging, new: draggingPosition)
        }
    }

    private var dragEndPoint: NSPoint?
    {
		didSet(oldPoint)
        {
			if let sourcePosition = sourcePosition
            {
                let startPoint = cablePointFor(position: sourcePosition)
                var invalidRectangle = NSRect()
                if let oldPoint = oldPoint
                {
                    invalidRectangle.origin.x = min(startPoint.x, oldPoint.x) - 1.0
                    invalidRectangle.origin.y = min(startPoint.y, oldPoint.y) - 1.0
                    invalidRectangle.size.width = abs(oldPoint.x - startPoint.x) + 2.0
                    invalidRectangle.size.height = abs(oldPoint.y - startPoint.y) + 2.0
                    self.setNeedsDisplay(invalidRectangle)
                }
                if let dragEndPoint = dragEndPoint
                {
                    invalidRectangle.origin.x = min(startPoint.x, dragEndPoint.x) - 1.0
                    invalidRectangle.origin.y = min(startPoint.y, dragEndPoint.y) - 1.0
                    invalidRectangle.size.width = abs(dragEndPoint.x - startPoint.x) + 2.0
                    invalidRectangle.size.height = abs(dragEndPoint.y - startPoint.y) + 2.0
                    self.setNeedsDisplay(invalidRectangle)
                }
            }
        }
    }

    private func calculatePositionNeedsDisplay(old: PlugPosition?, new: PlugPosition?)
    {
        if old != new
        {
            if let old = old
            {
                self.setNeedsDisplay(rectForSockets(plugPosition: old))
            }
            if let new = new
            {
                self.setNeedsDisplay(rectForSockets(plugPosition: new))
            }
        }
    }

    override func mouseDown(with theEvent: NSEvent)
    {
        // Check if it is over a socket and handle if it is.
        let clickLocation = self.convert(theEvent.locationInWindow, from: nil)
        sourcePosition = self.clickedPosition(location: clickLocation)
        if sourcePosition != nil
        {
            draggingPosition = nil
            self.setNeedsDisplay(rectForSockets(plugPosition: sourcePosition!))
        }
    }

    override func mouseDragged(with theEvent: NSEvent)
    {
        if let sourcePosition = self.sourcePosition
        {
            let clickLocation = self.convert(theEvent.locationInWindow, from: nil)
            /*
			 *  If over a socket, need to draw the selection around the socket.
			 */
            let draggingPosition = self.clickedPosition(location: clickLocation)
			if draggingPosition != nil
            {
				if    draggingPosition != self.draggingPosition
                   && draggingPosition != sourcePosition
                {
                    self.draggingPosition = draggingPosition
                }
            }
            else
            {
                self.draggingPosition = nil
            }
            /*
			 *  Invalidate the rectangle between the source socket and here to
			 *  ensure the line is drawn.
             */
            dragEndPoint = clickLocation
        }
    }

    override func mouseUp(with theEvent: NSEvent)
    {
        // Check if it is over a socket and handle if it is.
        if let sourcePosition = sourcePosition
        {
            let clickLocation = self.convert(theEvent.locationInWindow, from: nil)
            if let destPosition = self.clickedPosition(location: clickLocation)
            {
                if let dataSource = dataSource
                {
                    dataSource.connectLetterPair(letterPair: (PlugboardView.plugToLetter[sourcePosition]!, PlugboardView.plugToLetter[destPosition]!),
                        						 plugboardView: self)
                    /*
					 *  We need to invalidate the rectangles for all apparently 
					 *  plugged in sockets to make them redraw, in case our 
					 *  connection unconnects something else.
                     */
                    for position in pluggedInSockets
                    {
                        let pluggedInLocation = self.rectForSockets(plugPosition: position)
                        self.setNeedsDisplay(pluggedInLocation)
                    }
                    pluggedInSockets = []
                }
            }
			self.sourcePosition = nil
            self.draggingPosition = nil
        }
    }

    private func clickedPosition(location: NSPoint) -> PlugPosition?
    {
        let positions = PlugboardView.plugToLetter.keys

        return positions.first
        {
            let currentPosition = $0
            let targetRect = rectForSockets(plugPosition: currentPosition)
            return NSPointInRect(location, targetRect)
        }
    }
}

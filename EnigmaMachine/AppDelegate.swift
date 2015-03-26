//
//  AppDelegate.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var showPrinterItem: NSMenuItem!

    var abstractEnigmas: [AbstractEnigmaController] = []

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "aWindowBecameMain:",
                                                                   name: NSWindowDidBecomeMainNotification,
            													 object: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        // Insert code here to tear down your application
    }

    @IBAction func showAbstractEnigma(sender: AnyObject)
    {
        var controller = AbstractEnigmaController()
        abstractEnigmas.append(controller)
        controller.showWindow(sender)
        // TODO: A mechanism to get rid of the controller when we are done
    }

    func setShowPrinterText(hidden: Boolean)
    {
    }

    @objc func aWindowBecameMain(theNotification: NSNotification)
    {
		if let window: NSWindow = theNotification.object as? NSWindow
        {
			if let enigmaController = findEnigmaControllerForWindow(window)
            {

            }
        }
    }

    func findEnigmaControllerForWindow(aWindow: NSWindow) -> AbstractEnigmaController?
    {
        for controller in abstractEnigmas
        {
            if controller.window === aWindow
            {
                return controller
            }
        }
        return nil;
    }
}


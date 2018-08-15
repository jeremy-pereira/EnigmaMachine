//
//  AppDelegate.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 24/02/2015.
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

    var currentEnigma: AbstractEnigmaController?
    {
		didSet(oldValue)
        {
            if let newValue = currentEnigma
            {
                setShowPrinterTitle(printerIsVisible: newValue.printerIsVisible)
            }
        }
    }

    @objc func aWindowBecameMain(theNotification: NSNotification)
    {
		if let window: NSWindow = theNotification.object as? NSWindow
        {
			if let enigmaController = findEnigmaControllerForWindow(window)
            {
				currentEnigma = enigmaController
            }
        }
    }

    func setShowPrinterTitle(printerIsVisible: Bool)
    {
        // TODO: Localisation needed
        if printerIsVisible
        {
            showPrinterItem.title = "Hide Printer"
        }
        else
        {
            showPrinterItem.title = "Show Printer"
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


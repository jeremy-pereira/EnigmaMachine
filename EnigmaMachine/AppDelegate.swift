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

    var abstractEnigmas: [AbstractEnigmaController] = []

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        // Insert code here to initialize your application
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

}


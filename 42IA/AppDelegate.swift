//
//  AppDelegate.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import ApiAI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
            button.action = #selector(AppDelegate.showUI)
        }
        
        configureDialogAPI()
        configure42API()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func configureDialogAPI() {
        let config = AIDefaultConfiguration()
        config.clientAccessToken = "273b11f8daea4bf1bbe986990c74b2cc"
        
        let api = ApiAI.shared()
        api?.configuration = config
    }
    
    func configure42API() {
        FTApi().getToken(nil)
    }

    @objc func showUI() {
        guard let button = statusItem.button else {
            return
        }
        
        if popover.isShown {
            popover.performClose(nil)
        }
        else {
            popover.contentViewController = FTMainViewController.newViewController()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
}


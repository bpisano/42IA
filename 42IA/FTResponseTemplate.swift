//
//  FTResponseTemplate.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTResponseTemplate: NSObject {
    
    func response(username: String, location: String?) -> (response: String, view: NSView?) {
        if location != nil {
            let availableTemplates = [
                "\(username) is located in \(location!).",
                "It looks like \(username) is in \(location!).",
                "\(username) is currently in \(location!). Say him hello !",
            ]
            let random = arc4random() % UInt32(availableTemplates.count)
            return (availableTemplates[Int(random)], logView(username: username, location: location))
        }
        else {
            let unavailableTemplate = [
                "\(username) is not available.",
                "\(username) is not at school.",
                "\(username) is not here. Blackhole is comming...",
            ]
            let random = arc4random() % UInt32(unavailableTemplate.count)
            return (unavailableTemplate[Int(random)], logView(username: username, location: location))
        }
    }
    
    private func logView(username: String, location: String?) -> NSView? {
        var topLevelObjects: NSArray?
        guard Bundle.main.loadNibNamed(NSNib.Name("FTLogView"), owner: self, topLevelObjects: &topLevelObjects) else {
            return nil
        }
        
        guard let logView = topLevelObjects!.first(where: { $0 is NSView }) as? FTLogView else {
            return nil
        }
        
        logView.usernameLabel.stringValue = username
        logView.locationLabel.stringValue = location == nil ? "Unavailable" : location!
        logView.set(state: location == nil ? .unavailable : .available)
        return logView
    }
}

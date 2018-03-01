//
//  FTLogIndicator.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTLogIndicator: NSView {

    override func awakeFromNib() {
        wantsLayer = true
        layer?.cornerRadius = frame.height / 2
        layer?.masksToBounds = true
    }
    
    func set(state: FTAvailableStatus) {
        if state == .available {
            layer?.backgroundColor = NSColor.green.cgColor
        }
        else {
            layer?.backgroundColor = NSColor.red.cgColor
        }
    }
    
}

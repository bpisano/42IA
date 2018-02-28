//
//  FTLogView.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

enum FTAvailableStatus {
    case available
    case unavailable
}

class FTLogView: NSView {

    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    @IBOutlet weak var availableView: NSView!
    
    override func awakeFromNib() {
        availableView.wantsLayer = true
        availableView.layer?.cornerRadius = availableView.frame.height / 2
        availableView.layer?.masksToBounds = true
    }
    
    func set(state: FTAvailableStatus) {
        if state == .available {
            availableView.layer?.backgroundColor = NSColor.green.cgColor
        }
        else {
            availableView.layer?.backgroundColor = NSColor.red.cgColor
        }
    }
}

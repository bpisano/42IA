//
//  FTProfilView.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTProfilView: NSView {
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var staffLabel: NSTextField!
    @IBOutlet weak var logIndicator: FTLogIndicator!
    @IBOutlet weak var levelLabel: NSTextField!
    @IBOutlet weak var levelIndicator: NSProgressIndicator!
    @IBOutlet weak var correctionPointLabel: NSTextField!
    @IBOutlet weak var walletLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    
    override func awakeFromNib() {
        staffLabel.wantsLayer = true
        staffLabel.layer?.cornerRadius = 2
        staffLabel.layer?.masksToBounds = true
    }
}

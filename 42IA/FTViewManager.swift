//
//  FTViewManager.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTViewManager: NSObject {
    
    func profilView(user: FTUser) -> NSView? {
        var topLevelObjects: NSArray?
        guard Bundle.main.loadNibNamed(NSNib.Name("FTProfilView"), owner: self, topLevelObjects: &topLevelObjects) else {
            return nil
        }
        
        guard let profilView = topLevelObjects!.first(where: { $0 is NSView }) as? FTProfilView else {
            return nil
        }
        
        profilView.nameLabel.stringValue = "\(user.firstName) \(user.lastName)"
        profilView.usernameLabel.stringValue = user.username
        profilView.emailLabel.stringValue = user.email
        profilView.levelLabel.stringValue = "Level \(user.level)"
        profilView.levelIndicator.doubleValue = user.levelProgress * 1000
        profilView.correctionPointLabel.stringValue = "\(user.correctionPoints)"
        profilView.walletLabel.stringValue = "\(user.wallet)"
        profilView.logIndicator.set(state: user.location == nil ? .unavailable : .available)
        profilView.locationLabel.stringValue = user.location == nil ? "Unavailable" : "\(user.location!)"
        profilView.staffLabel.isHidden = !user.isStaff
        return profilView
    }
    
    func logView(username: String, location: String?) -> NSView? {
        var topLevelObjects: NSArray?
        guard Bundle.main.loadNibNamed(NSNib.Name("FTLogView"), owner: self, topLevelObjects: &topLevelObjects) else {
            return nil
        }
        
        guard let logView = topLevelObjects!.first(where: { $0 is NSView }) as? FTLogView else {
            return nil
        }
        
        logView.usernameLabel.stringValue = username
        logView.locationLabel.stringValue = location == nil ? "Unavailable" : location!
        logView.logIndicator.set(state: location == nil ? .unavailable : .available)
        return logView
    }
}

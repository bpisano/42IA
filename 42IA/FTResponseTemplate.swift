//
//  FTResponseTemplate.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTResponseTemplate: NSObject {
    
    func response(username: String, location: String?) -> String {
        if location != nil {
            let availableTemplates = ["\(username) is located in \(location!)."]
            let random = arc4random() % UInt32(availableTemplates.count)
            return availableTemplates[Int(random)]
        }
        else {
            let unavailableTemplate = ["\(username) is not available."]
            let random = arc4random() % UInt32(unavailableTemplate.count)
            return unavailableTemplate[Int(random)]
        }
    }
}

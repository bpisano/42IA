//
//  FTUser.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import SwiftyJSON

struct FTUser {
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var level: Double
    var levelProgress: Double {
        return level - floor(level)
    }
    var correctionPoints: Int
    var wallet: Int
    var isStaff: Bool
    var location: String?
    var projects: [FTProject]
    var JSONData = JSON()
}

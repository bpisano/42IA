//
//  FTApi.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class FTApi: NSObject {
    
    static var token = String()
    static var currentUserID: String? {
        guard let id = UserDefaults.standard.value(forKey: "currentUserID") as? String else {
            return nil
        }
        
        return id
    }
    
    func getToken(_ completion: ((_ error: Error?, _ token: String?) -> Void)?) {
        let url = "https://api.intra.42.fr/oauth/token"
        let parameters = ["grant_type" : "client_credentials",
                          "client_id": "d18ef9689f93d8811133f1a6567fe01f9a602d25d66bbd5fc42ecfb267500beb",
                          "client_secret": "749e2924cfdb655be9fc8a00fd01e68ba839b388cf0b26891ead541a5e673631"]
        
        Alamofire.request(url, method: .post, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
                completion?(error, nil)
            case .success(let value):
                let token = JSON(value)["access_token"].stringValue
                
                print("[42API] Token : \(token)")
                FTApi.token = token
                completion?(nil, token)
            }
        }
    }
    
    /*
    func getAllUsers(page: Int, _ completion: ((_ error: Error?, _ users: [FTUser]?) -> Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/campus/9/users?page=\(page)&per_page=100")
        let head = "Bearer " + FTApi.token
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue(head, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).validate().responseJSON { (response) in
            guard JSON(response.result.value ?? "").count > 0 else {
                completion?(nil, nil)
                return
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                self.getAllUsers(page: page + 1, { (error, users) in
                    switch response.result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion?(error, nil)
                        return
                    case .success(let value):
                        var finalUsers = users ?? [FTUser]()
                        for userJSON in JSON(value) {
                            let user = FTUser(id: userJSON.1["id"].stringValue, username: userJSON.1["login"].stringValue, JSONData: userJSON.1)
                            finalUsers.append(user)
                        }
                        completion?(nil, finalUsers)
                    }
                })
            })
        }
    }*/
    
    func getUser(_ username: String, _ completion: ((_ error: Error?, _ user: FTUser?) -> Void)?) {
        print("[42API] getting \(username) data...")
        
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(username)")
        let head = "Bearer " + FTApi.token
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue(head, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).validate().responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
                completion?(error, nil)
                return
            case .success(let value):
                let jsonValue = JSON(value)
                let id = jsonValue["id"].stringValue
                let firstName = jsonValue["first_name"].stringValue
                let lastName = jsonValue["last_name"].stringValue
                let email = jsonValue["email"].stringValue
                let level = jsonValue["cursus_users"][0]["level"].doubleValue
                let correctionPoints = jsonValue["correction_point"].intValue
                let wallet = jsonValue["wallet"].intValue
                let isSatff = jsonValue["staff?"].boolValue
                let location = jsonValue["location"] == JSON.null ? nil : jsonValue["location"].stringValue
                let user = FTUser(id: id,
                                  username: username,
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: email,
                                  level: level,
                                  correctionPoints: correctionPoints,
                                  wallet: wallet,
                                  isStaff: isSatff,
                                  location: location,
                                  projects: [],
                                  JSONData: jsonValue)
                completion?(nil, user)
            }
        }
    }
    
    func getUserLocation(_ username: String, _ completion: ((_ error: Error?, _ location: String?) -> Void)?) {
        print("[42API] getting \(username) location...")
        
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(username)/locations")
        let head = "Bearer " + FTApi.token
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue(head, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).validate().responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
                completion?(error, nil)
                return
            case .success(let value):
                let jsonValue = JSON(value)[0]
                let connected = jsonValue["end_at"] == JSON.null
                if connected {
                    completion?(nil, jsonValue["host"].stringValue)
                }
                else {
                    completion?(nil, nil)
                }
            }
        }
    }
    
    func setCurrentUserID(_ id: String) {
        UserDefaults.standard.set(id, forKey: "currentUserID")
    }
}

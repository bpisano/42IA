//
//  FTRequestHandler.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import ApiAI

class FTRequestHandler: NSObject {
    
    func getAnswer(request: String, _ completion: ((_ error: NSError?, _ response: FTResponse?) -> Void)?) {
        handleRequest(request: request) { (error, response) in
            guard error == nil else {
                completion?(error, nil)
                return
            }
            
            completion?(nil, response)
        }
    }
    
    private func handleRequest(request: String, _ completion: ((_ error: NSError?, _ response: FTResponse?) -> Void)?) {
        getDataFor(request: request) { (error, intentName, parameters) in
            guard error == nil else {
                completion?(error, nil)
                return
            }
            
            print("[ApiAI] Intent name : \(intentName!)")
            
            switch intentName! {
            case "Log":
                guard let username = parameters!["User"] as? AIResponseParameter else {
                    completion?(nil, nil)
                    return
                }
                
                FTApi().getUserLocation(username.stringValue, { (error, location) in
                    guard error == nil else {
                        completion?(error! as NSError, nil)
                        return
                    }
                    
                    guard username.stringValue != nil else {
                        completion?(nil, FTResponse(response: "I'm sorry, I was not able to connect to the server :/", view: nil))
                        return
                    }
                    
                    let response = FTResponseManager().response(intentName: intentName!, parameters: ["username": username.stringValue, "location": location])
                    completion?(nil, response)
                })
            case "Profil":
                guard let username = parameters!["User"] as? AIResponseParameter else {
                    completion?(nil, nil)
                    return
                }
                
                FTApi().getUser(username.stringValue, { (error, user) in
                    guard error == nil else {
                        completion?(error! as NSError, nil)
                        return
                    }
                    
                    guard user != nil else {
                        completion?(nil, FTResponse(response: "Maybe this user doesn't exist :/", view: nil))
                        return
                    }
                    
                    let response = FTResponseManager().response(intentName: intentName!, parameters: ["user": user, "parameters": parameters])
                    completion?(nil, response)
                })
            default:
                completion?(nil, FTResponse(response: "It looks like I was not able to understand a fuckin word 🤔", view: nil))
            }
        }
    }
    
    private func getDataFor(request: String, _ completion: ((_ error: NSError?, _ intentName: String?, _ parameters: [AnyHashable: Any]?) -> Void)?) {
        let req = ApiAI.shared().textRequest()
        
        req?.query = request
        req?.setMappedCompletionBlockSuccess({ (returnedRequest, responseData) in
            let data = responseData as! AIResponse
            completion?(nil, data.result.metadata.intentName, data.result.parameters)
        }, failure: { (returnedRequest, error) in
            print(error!.localizedDescription)
            completion?(error! as NSError, nil, nil)
        })
        
        ApiAI.shared().enqueue(req)
        print("[ApiAI] Asking request...")
    }
}

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
    
    func getAnswer(request: String, _ completion: ((_ error: NSError?, _ answer: String?) -> Void)?) {
        handleRequest(request: request) { (error, response) in
            guard error == nil else {
                completion?(error, nil)
                return
            }
            
            completion?(nil, response)
        }
    }
    
    func handleRequest(request: String, _ completion: ((_ error: NSError?, _ answer: String?) -> Void)?) {
        getDataFor(request: request) { (error, intentName, parameters) in
            guard error == nil else {
                completion?(error, nil)
                return
            }
            
            print("[ApiAI] Intent name : \(intentName!)")
            switch intentName! {
            case "Log":
                let username = (parameters!["User"] as! AIResponseParameter).stringValue
                FTApi().getUserLocation(username!, { (error, location) in
                    guard error == nil else {
                        completion?(error! as NSError, nil)
                        return
                    }
                    
                    completion?(nil, FTResponseTemplate().response(username: username!, location: location))
                })
            default:
                completion?(nil, "It's a very good question...")
            }
        }
    }
    
    func getDataFor(request: String, _ completion: ((_ error: NSError?, _ intentName: String?, _ parameters: [AnyHashable: Any]?) -> Void)?) {
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

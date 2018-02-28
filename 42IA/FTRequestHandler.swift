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
    
    func getAnswer(request: String, _ completion: ((_ error: NSError?, _ answer: String?, _ view: NSView?) -> Void)?) {
        handleRequest(request: request) { (error, response, view) in
            guard error == nil else {
                completion?(error, nil, nil)
                return
            }
            completion?(nil, response, view)
        }
    }
    
    private func handleRequest(request: String, _ completion: ((_ error: NSError?, _ answer: String?, _ view: NSView?) -> Void)?) {
        getDataFor(request: request) { (error, intentName, parameters) in
            guard error == nil else {
                completion?(error, nil, nil)
                return
            }
            
            print("[ApiAI] Intent name : \(intentName!)")
            switch intentName! {
            case "Log":
                let username = (parameters!["User"] as! AIResponseParameter).stringValue
                FTApi().getUserLocation(username!, { (error, location) in
                    guard error == nil else {
                        completion?(error! as NSError, nil, nil)
                        return
                    }
                    
                    let response = FTResponseTemplate().response(username: username!, location: location)
                    completion?(nil, response.response, response.view)
                })
            default:
                completion?(nil, "It looks like I was not able to understand a fuckin word 🤔", nil)
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

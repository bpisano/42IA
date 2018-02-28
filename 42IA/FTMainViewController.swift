//
//  FTMainViewController.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTMainViewController: NSViewController {

    @IBOutlet weak var askTextField: NSTextField!
    @IBOutlet weak var responseLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askTextField.stringValue = ""
        askTextField.becomeFirstResponder()
        responseLabel.alphaValue = 0
    }
    
    @IBAction func executeRequest(_ sender: Any) {
        guard askTextField.stringValue != "" else {
            return
        }
        
        FTRequestHandler().getAnswer(request: askTextField.stringValue) { (error, response) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self.responseLabel.stringValue = response!
            self.responseLabel.alphaValue = 1
        }
    }
    
}


extension FTMainViewController {
    static func newViewController() -> FTMainViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let id = NSStoryboard.SceneIdentifier("FTMainViewController")
        
        guard let controller = storyboard.instantiateController(withIdentifier: id) as? FTMainViewController else {
            fatalError("No Controller found")
        }
        
        return controller
    }
}

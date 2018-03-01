//
//  FTMainViewController.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTMainViewController: NSViewController {

    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var responseLabel: NSTextField!
    @IBOutlet weak var askTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askTextField.stringValue = ""
        askTextField.becomeFirstResponder()
        responseLabel.alphaValue = 0
    }
    
    override func viewDidAppear() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        addResponseView(FTViewManager().exampleView())
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func executeRequest(_ sender: Any) {
        guard askTextField.stringValue != "" else {
            return
        }
        
        animateRequest()
        FTRequestHandler().getAnswer(request: askTextField.stringValue) { (error, response) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response else {
                print("No response")
                return
            }
            
            self.responseLabel.stringValue = response.response
            self.clearResponseView()
            self.addResponseView(response.view)
            self.animateResponse()
        }
    }
    
    private func clearResponseView() {
        for subview in self.containerView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func addResponseView(_ view: NSView?) {
        if let view = view {
            view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
            self.containerView.addSubview(view)
        }
    }
    
    private func animateResponse() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.2
            self.responseLabel.animator().alphaValue = 1
        })
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (_) in
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.2
                self.containerView.animator().alphaValue = 1
            })
        }
    }
    
    private func animateRequest() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.2
            self.responseLabel.animator().alphaValue = 0
        })
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (_) in
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.2
                self.containerView.animator().alphaValue = 0
            })
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

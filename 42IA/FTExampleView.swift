//
//  FTExampleView.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTExampleView: NSView {
    
    override func awakeFromNib() {
        changeExamples()
        animate()
    }
    
    private func animate() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (_) in
            self.hideLabels()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.changeExamples()
                self.showLabels()
            }
        }
    }
    
    private func changeExamples() {
        let examples = ["Where is bpisano ?",
                        "What is the level of xamartin ?",
                        "Show me the skill of anamsell",
                        "Show me the profil of bodo",
                        "How many wallet have htaillef ?",
                        "Give me some infos about flombard",
                        "Where can I find albarbos ?",
                        "Is bpisano available ?",
                        "Is tle-coza logged ?",
                        "What is the money of xamartin ?",
                        "Is alruntz at school ?",
                        "Give me informations about max"]
        for i in 1...3 {
            let random = arc4random() % UInt32(examples.count)
            (viewWithTag(i) as! NSTextField).stringValue = examples[Int(random)]
        }
    }
    
    private func showLabels() {
        for i in 1...3 {
            Timer.scheduledTimer(withTimeInterval: Double(i) / 8, repeats: false, block: { (_) in
                NSAnimationContext.runAnimationGroup({ (context) in
                    context.duration = 1
                    self.viewWithTag(i)!.animator().alphaValue = 1
                })
            })
        }
    }
    
    private func hideLabels() {
        for i in 1...3 {
            Timer.scheduledTimer(withTimeInterval: Double(i) / 8, repeats: false, block: { (_) in
                NSAnimationContext.runAnimationGroup({ (context) in
                    context.duration = 0.6
                    self.viewWithTag(i)!.animator().alphaValue = 0
                })
            })
        }
    }
    
}

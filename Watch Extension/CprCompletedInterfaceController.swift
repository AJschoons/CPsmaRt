//
//  CprCompletedInterfaceController.swift
//  CPsmaRt
//
//  Created by adam on 2/20/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import WatchKit
import Foundation

class CprCompletedInterfaceController: WKInterfaceController {
    
    private let delegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
    
    @IBAction func onFinishButton() {
        finish()
    }

    override func willActivate() {
        super.willActivate()
        
        WKInterfaceDevice.currentDevice().playHaptic(.Stop)
    }
    
    private func finish() {
        delegate.session?.sendMessage(["finished" : true], replyHandler: nil, errorHandler: nil)
        
        popToRootController()
    }

}

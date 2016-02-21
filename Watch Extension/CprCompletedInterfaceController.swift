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

    @IBAction func onFinishButton() {
        finish()
    }

    override func willActivate() {
        super.willActivate()
        
        WKInterfaceDevice.currentDevice().playHaptic(.Stop)
    }
    
    private func finish() {
        popToRootController()
    }

}

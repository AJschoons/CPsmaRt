//
//  StartInterfaceController.swift
//  CPsmaRt
//
//  Created by adam on 2/20/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import WatchKit
import Foundation


class StartInterfaceController: WKInterfaceController {

    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var currentBpmLabel: WKInterfaceLabel!
    @IBOutlet var bpmSlider: WKInterfaceSlider!
    
    @IBAction func onBpmSliderChange(value: Float) {
        currentBpmLabel.setText(String(Int(value)))
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

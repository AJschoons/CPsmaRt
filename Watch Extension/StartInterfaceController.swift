//
//  StartInterfaceController.swift
//  CPsmaRt
//
//  Created by adam on 2/20/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class StartInterfaceController: WKInterfaceController {

    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var currentBpmLabel: WKInterfaceLabel!
    @IBOutlet var bpmSlider: WKInterfaceSlider!
    
    private var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    private var bpm: Int = 100 {
        didSet { currentBpmLabel.setText(String(bpm)) }
    }
    
    @IBAction func onStartButton() {
        //pushControllerWithName("CPR", context: ["bpm" : bpm])
        
        session?.sendMessage(["start" : bpm], replyHandler: { reply in
            // handle reply from iPhone app here
            print("watch: got reply")
            print(reply)
            if let bpm = reply["b"] as? Int, currentCompression = reply["c"] as? Int {
                let cprState = CPRState(bpm: bpm, currentCompression: currentCompression)
                self.pushControllerWithName("CPR", context: cprState)
            }

            }, errorHandler: { error in
            // catch any errors here
            print("watch: got reply error")
        })
    }
    
    
    @IBAction func onBpmSliderChange(value: Float) {
        bpm = Int(value)
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        session = WCSession.defaultSession()
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

extension StartInterfaceController: WCSessionDelegate {

}

//
//  CprInterfaceController.swift
//  CPsmaRt
//
//  Created by adam on 2/20/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

class CprInterfaceController: WKInterfaceController {
    
    @IBOutlet var timer: WKInterfaceTimer!

    @IBAction func onStopButton() {
        stopCpr()
    }
    
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    
    private var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    private var cpr: CPR! {
        didSet {
            cpr.delegate = self
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        session = WCSession.defaultSession()
        
        if let cprState = context as? CPRState {
            startCprWithState(cprState)
        } else {
            updateCprState()
        }
    }

    override func willActivate() {
        super.willActivate()
        
        updateCprState()
    }
    
    private func startWorkoutSession() {
        workoutSession = HKWorkoutSession(activityType: .Walking, locationType: .Indoor)
        workoutSession!.delegate = self
        healthStore.startWorkoutSession(workoutSession!)
    }
    
    private func endWorkoutSession() {
        guard let workoutSession = workoutSession else { return }
        healthStore.endWorkoutSession(workoutSession)
    }
    
    private func startCprWithState(state: CPRState) {
        cpr = CPR(state: state)
        cpr.startCPR()
        timer.start()
        startWorkoutSession()
    }
    
    private func updateCprState() {
        session?.sendMessage(["getCprState" : true], replyHandler: { reply in
            dispatch_async(dispatch_get_main_queue(), {
                print("watch: got reply")
                print(reply)
                
                if let bpm = reply["b"] as? Int, currentCompression = reply["c"] as? Int {
                    let cprState = CPRState(bpm: bpm, currentCompression: currentCompression)
                    
                    if self.cpr != nil {
                        self.cpr.updateWithState(cprState)
                    } else {
                        self.startCprWithState(cprState)
                    }
                }
            })
            }, errorHandler: { error in
                // catch any errors here
                print("watch: got reply error (will activate)")
        })
    }
    
    private func stopCpr() {
        cpr?.stopCPR()
        timer.stop()
        endWorkoutSession()
        
        session?.sendMessage(["stop" : true], replyHandler: { reply in
            dispatch_async(dispatch_get_main_queue(), {
                print("watch: got reply")
                
                self.pushControllerWithName("CPR Done", context: nil)
            })
            }, errorHandler: { error in
                // catch any errors here
                print("watch: got reply error (will activate)")
            }
        )
    }
}

extension CprInterfaceController: CPRDelegate {
    func onCompression() {
        print("COMPRESS")
        WKInterfaceDevice.currentDevice().playHaptic(.Click)
    }
    
    func onBreath() {
        print("BREATH")
        WKInterfaceDevice.currentDevice().playHaptic(.Notification)
    }
}

extension CprInterfaceController: HKWorkoutSessionDelegate {
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        
    }
}

extension CprInterfaceController: WCSessionDelegate {

}

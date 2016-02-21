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

class CprInterfaceController: WKInterfaceController {
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var animatedHeartRate: WKInterfaceImage!

    @IBAction func onStopButton() {
        stopCpr()
    }
    
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    
    private let delegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
    
    private var cpr: CPR! {
        didSet {
            cpr.delegate = self
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
        
        animatedHeartRate.setImageNamed("animateHeartRate")
        animatedHeartRate.startAnimatingWithImagesInRange(NSRange(location: 1, length: 20), duration: Double(60 / state.bpm), repeatCount: Int.max)
    }
    
    private func updateCprState() {
        delegate.session?.sendMessage(["getCprState" : true], replyHandler: { reply in
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
        
        delegate.session?.sendMessage(["stop" : true], replyHandler: { reply in
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
        animatedHeartRate.startAnimating()
    }
    
    func onBreath() {
        print("BREATH")
        WKInterfaceDevice.currentDevice().playHaptic(.Notification)
        animatedHeartRate.stopAnimating()
    }
}

extension CprInterfaceController: HKWorkoutSessionDelegate {
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        
    }
}

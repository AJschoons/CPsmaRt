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

    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        guard let context = context else { return }
        guard let bpm = context["bpm"] as? Int else { return }
        
        timer.start()
        startWorkoutSession()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func onCompressionPeriod() {
        //WKInterfaceDevice.currentDevice().playHaptic(.Click)
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
}

extension CprInterfaceController: HKWorkoutSessionDelegate {
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        
    }
}

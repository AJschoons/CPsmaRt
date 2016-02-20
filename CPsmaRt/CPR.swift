//
//  CPR.swift
//  CPsmaRt
//
//  Created by adam on 2/20/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import Foundation
import HealthKit

protocol CPRDelegate: class {
    func onCompression()
    func onBreath()
}

class CPR: NSObject {
    
    weak var delegate: CPRDelegate?
    
    private var bpm = 100 {
        didSet { compressionPeriod = 60.0 / Double(bpm) }
    }
    private func setBpm(bpm: Int) { self.bpm = bpm }
    
    private var compressionPeriod = 0.0 // Period in seconds between compressions
    private var compressionsCount = 0
    private let CompressionsUntilBreath = 5
    
    private var shouldBeGivingBreath = false
    private var remainingBreathCount = 2
    private var rescueBreathTimeCount = 0.0
    private let RescueBreathDurationInSeconds = 2.0
    private let NumberOfBreathsBetweenCompressions = 2
    
    private var timer: NSTimer?
    
    init(bpm: Int) {
        super.init()
        
        setBpm(bpm)
        remainingBreathCount = NumberOfBreathsBetweenCompressions
    }
    
    func onCompressionPeriod() {
        if shouldBeGivingBreath {
            handleShouldBeGivingBreathOnCompressionPeriod()
        } else {
            handleShouldBeGivingCompressionOnCompressionPeriod()
        }
    }
    
    private func handleShouldBeGivingBreathOnCompressionPeriod() {
        rescueBreathTimeCount += compressionPeriod
        
        // Time to give a breath
        if rescueBreathTimeCount > RescueBreathDurationInSeconds {
            rescueBreathTimeCount = 0.0
            
            // Still have breaths to give, so give a breath
            if remainingBreathCount > 0 {
                remainingBreathCount -= 1
                
                delegate?.onBreath()
            }
                // Done giving breaths
            else {
                // Reset everything and start giving compressions again
                shouldBeGivingBreath = false
                remainingBreathCount = NumberOfBreathsBetweenCompressions
            }
            
        }
    }
    
    private func handleShouldBeGivingCompressionOnCompressionPeriod() {
        compressionsCount += 1
        
        // Time to be giving breath
        if compressionsCount > CompressionsUntilBreath {
            shouldBeGivingBreath = true
            rescueBreathTimeCount = RescueBreathDurationInSeconds
            compressionsCount = 0
            
        }
        // Should be giving compression
        else {
            delegate?.onCompression()
        }
    }
    
    func startCPR() {
        if NSThread.isMainThread() {
            startTimer()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.startTimer()
            })
        }
    }
    
    private func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(compressionPeriod, target: self, selector: "onCompressionPeriod", userInfo: nil, repeats: true)
    }
    
    func stopCPR() {
        timer?.invalidate()
    }
}
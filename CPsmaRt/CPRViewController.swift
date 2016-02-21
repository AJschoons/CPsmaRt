//
//  ViewController.swift
//  CPsmaRt
//
//  Created by adam on 2/19/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import UIKit

class CPRViewController: UIViewController {
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentBPMLabel: UILabel!
    
    @IBOutlet weak var stopView: UIView!
    
    private var bpm: Int = 100 {
        didSet { currentBPMLabel.text = String(bpm) }
    }
    
    private let delegate = UIApplication.sharedApplication().delegate! as! AppDelegate
    
    @IBAction func onBPMSlider(sender: AnyObject) {
        bpm = Int(slider.value)
    }
    
    @IBAction func onStartCPRButton(sender: AnyObject) {
        startCPR()
    }
    
    @IBAction func onStopCPRButton(sender: AnyObject) {
        stopCPR()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetStartView()
        setStopViewHidden(true)
        
        delegate.cprViewController = self
    }
    
    override func viewDidAppear(animated: Bool) {
        if delegate.cprIsRunning {
            setStopViewHidden(false)
        } else {
            setStopViewHidden(true)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func updateForStartCPR() {
        UIView.animateWithDuration(0.5) {
            self.setStopViewHidden(false)
        }
    }
    
    func updateForStopCPR() {
        UIView.animateWithDuration(0.5) {
            self.setStopViewHidden(true)
        }
    }
    
    private func startCPR() {
        updateForStartCPR()
        
        delegate.startCPRFromPhoneWithBPM(bpm)
    }
    
    private func stopCPR() {
        resetStartView()
        
        updateForStopCPR()
        
        delegate.stopCPRFromPhone()
    }
    
    private func resetStartView() {
        slider.setValue(100.0, animated: false)
        bpm = Int(slider.value)
    }
    
    private func setStopViewHidden(hidden: Bool) {
        stopView.alpha = hidden ? 0.0 : 1.0
    }
}

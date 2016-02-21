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
    
    private weak var cprDoneViewController: CPRDoneViewController?
    
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
        
        dismissCPRDone()
    }
    
    func updateForStopCPR() {
        UIView.animateWithDuration(0.5) {
            self.setStopViewHidden(true)
        }
        
        presentCPRDone()
    }
    
    func dismissCPRDone() {
        cprDoneViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    
    private func presentCPRDone() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CPRDoneViewController")
        guard let cdvc = vc as? CPRDoneViewController else { return }
        
        cdvc.modalTransitionStyle = .CrossDissolve
        cdvc.modalPresentationStyle = .OverFullScreen
        
        cprDoneViewController = cdvc
        
        presentViewController(cdvc, animated: true, completion: nil)
    }
}

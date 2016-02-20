//
//  ViewController.swift
//  CPsmaRt
//
//  Created by adam on 2/19/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let cpr = CPR(bpm: 100)
    
    var compressionAudioPlayer: AVAudioPlayer!
    var giveRescueBreathAudioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cpr.delegate = self
        
        
        do {
            let beepPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType: "mp3")!)
            compressionAudioPlayer = try AVAudioPlayer(contentsOfURL: beepPath)
            compressionAudioPlayer.prepareToPlay()
            
            let giveRescueBreathPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("giverescuebreath", ofType: "mp3")!)
            giveRescueBreathAudioPlayer = try AVAudioPlayer(contentsOfURL: giveRescueBreathPath)
            giveRescueBreathAudioPlayer.prepareToPlay()
        } catch {
            // Do nothing
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //cpr.startCPR()
    }

    
}

extension ViewController: CPRDelegate {
    func onCompression() {
        //print("COMPRESS")
        //compressionAudioPlayer.play()
    }
    
    func onBreath() {
        //print("BREATH")
        //giveRescueBreathAudioPlayer.play()
    }
}


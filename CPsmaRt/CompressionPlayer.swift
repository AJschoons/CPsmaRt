//
//  CompressionPlayer.swift
//  CPsmaRt
//
//  Created by adam on 2/20/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import Foundation
import AVFoundation

class CompressionPlayer {
    private var player1: AVAudioPlayer!
    private var player2: AVAudioPlayer!
    private var player3: AVAudioPlayer!
    private var player4: AVAudioPlayer!
    
    private var playerToPlay = 0
    
    init() {
        do {
            let beepPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType: "mp3")!)
            player1 = try AVAudioPlayer(contentsOfURL: beepPath)
            player1.prepareToPlay()
            
            player2 = try AVAudioPlayer(contentsOfURL: beepPath)
            player2.prepareToPlay()
            
            player3 = try AVAudioPlayer(contentsOfURL: beepPath)
            player3.prepareToPlay()
            
            player4 = try AVAudioPlayer(contentsOfURL: beepPath)
            player4.prepareToPlay()
        } catch {
            // Do nothing
        }
    }
    
    func play() {
        switch playerToPlay {
        case 0:
            player1.play()
        case 1:
            player2.play()
        case 2:
            player3.play()
        case 3:
            player4.play()
        default:
            break
        }
        
        playerToPlay += 1
        
        if playerToPlay > 3 {
            playerToPlay = 0
        }
    }
}
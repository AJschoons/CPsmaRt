//
//  AppDelegate.swift
//  CPsmaRt
//
//  Created by adam on 2/19/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import UIKit
import WatchConnectivity
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let audioSession = AVAudioSession.sharedInstance()
    
    var backgroundTaskIndentifier: UIBackgroundTaskIdentifier?

    var cpr: CPR? {
        didSet {
            cpr?.delegate = self
            
            do {
                compressionPlayer = CompressionPlayer()
                
                let giveRescueBreathPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("giverescuebreath", ofType: "mp3")!)
                giveRescueBreathAudioPlayer = try AVAudioPlayer(contentsOfURL: giveRescueBreathPath)
                giveRescueBreathAudioPlayer.prepareToPlay()
            } catch {
                // Do nothing
            }
        }
    }
    var compressionPlayer: CompressionPlayer!
    var giveRescueBreathAudioPlayer: AVAudioPlayer!
    
    private var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: CPRDelegate {
    func onCompression() {
        print("COMPRESS")
        compressionPlayer.play()
    }
    
    func onBreath() {
        print("BREATH")
        giveRescueBreathAudioPlayer.play()
    }
}

extension AppDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        if let bpm = message["start"] as? Int {
            
            backgroundTaskIndentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                guard let backgroundTaskIndentifier = self.backgroundTaskIndentifier else { return }
                UIApplication.sharedApplication().endBackgroundTask(backgroundTaskIndentifier)
            })
            
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                try audioSession.setActive(true)
                
                let cprState = CPRState(bpm: bpm, currentCompression: 0)
                cpr = CPR(state: cprState)
                cpr!.startCPR()
                
                print("started cpr")
                replyHandler(["started": true])
            } catch {
                print("problem setting up audio session")
                replyHandler(["started": false])
            }
        }
        
        
    }
    
}


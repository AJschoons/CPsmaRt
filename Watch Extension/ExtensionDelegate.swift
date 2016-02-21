//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by adam on 2/19/16.
//  Copyright © 2016 Spartan Software, LLC. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    private(set) var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        session = WCSession.defaultSession()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}


extension ExtensionDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        // Start CPR
        if let bpm = message["start"] as? Int {
            let cprState = CPRState(bpm: bpm)
            
            //dispatch_async(dispatch_get_main_queue(), {
            //self.pushControllerWithName("CPR", context: cprState)
            //})
        }
    }
}

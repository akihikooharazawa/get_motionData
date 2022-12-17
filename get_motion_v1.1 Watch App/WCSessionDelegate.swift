//
//  WCSessionDelegate.swift
//  get_motion_v1.1 Watch App
//
//  Created by OharazawaAkihiko on 2022/12/17.
//

import Foundation
import WatchConnectivity

class ConnectivityProvider: NSObject, WCSessionDelegate {
    
    private let session: WCSession
    
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }
    
    func send(message: [String:Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // code
    }
}

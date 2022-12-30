//
//  WCSessionDelegate.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/17.
//

import Foundation
import WatchConnectivity

final class ViewModel: NSObject, ObservableObject, WCSessionDelegate {
    
    var session: WCSession
    
    /*
    @Published var message_time: String = ""
    @Published var message_attitude_pitch: String = ""
    @Published var message_attitude_roll: String = ""
    @Published var message_attitude_yaw: String = ""
    */
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("iPhone session has activated!")
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    // iphone側でmessageを受け取る
    /*func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Void) {
        //replyHandler(["reply": "OK"])
        DispatchQueue.main.async {
            if let time = message["timestamp"] as? String {
                self.message_time = time
            }
            if let pitch = message["attitude_pitch"] as? String {
                self.message_attitude_pitch = pitch
            }
            if let roll = message["attitude_roll"] as? String {
                self.message_attitude_roll = roll
            }
            if let yaw = message["attitude_yaw"] as? String {
                self.message_attitude_yaw = yaw
            }
        }
    }*/
    
    // iphone側でfileを受け取る
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = url.appendingPathComponent(file.fileURL.lastPathComponent)
        try! FileManager.default.copyItem(at: file.fileURL, to:dest)
    }
}


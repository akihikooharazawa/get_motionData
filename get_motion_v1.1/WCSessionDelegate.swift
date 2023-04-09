//
//  WCSessionDelegate.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/17.
//

import Foundation
import WatchConnectivity
import CoreMotion

final class ViewModel: NSObject, ObservableObject, WCSessionDelegate {

    var session: WCSession
    @Published var roll: Double = 0
    @Published var pitch: Double = 0
    @Published var yaw: Double = 0
    @Published var gravity_x: Double = 0
    @Published var gravity_y: Double = 0
    @Published var gravity_z: Double = 0
    @Published var rotation_x: Double = 0
    @Published var rotation_y: Double = 0
    @Published var rotation_z: Double = 0
    @Published var acc_x: Double = 0
    @Published var acc_y: Double = 0
    @Published var acc_z: Double = 0
    
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
    
    // iPhone側でmessageDataを受け取る
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if let attitudeData = message["attitude"] as? [String: Double],
               let gravityData = message["gravity"] as? [String: Double],
               let rotationRateData = message["rotationRate"] as? [String: Double],
               let userAccelerationData = message["userAcceleration"] as? [String: Double] {
                
                self.roll = attitudeData["roll"] ?? 0
                self.pitch = attitudeData["pitch"] ?? 0
                self.yaw = attitudeData["yaw"] ?? 0
                
                self.gravity_x = gravityData["x"] ?? 0
                self.gravity_y = gravityData["y"] ?? 0
                self.gravity_z = gravityData["z"] ?? 0

                self.rotation_x = rotationRateData["x"] ?? 0
                self.rotation_y = rotationRateData["y"] ?? 0
                self.rotation_z = rotationRateData["z"] ?? 0

                self.acc_x = userAccelerationData["x"] ?? 0
                self.acc_y = userAccelerationData["y"] ?? 0
                self.acc_z = userAccelerationData["z"] ?? 0
            }
        }
        replyHandler(["reply": "OK"])
    }

    
    // iphone側でfileを受け取る
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = url.appendingPathComponent(file.fileURL.lastPathComponent)
        try! FileManager.default.copyItem(at: file.fileURL, to:dest)
    }
}

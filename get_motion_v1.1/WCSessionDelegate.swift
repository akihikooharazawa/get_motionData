//
//  WCSessionDelegate.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/17.
//

import Foundation
import WatchConnectivity
import CoreMotion
import SwiftUI

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
    
    // 配列を初期化
    @Published var rollData: [Double] = []
    @Published var pitchData: [Double] = []
    @Published var yawData: [Double] = []
    @Published var gravityXData: [Double] = []
    @Published var gravityYData: [Double] = []
    @Published var gravityZData: [Double] = []
    @Published var rotationXData: [Double] = []
    @Published var rotationYData: [Double] = []
    @Published var rotationZData: [Double] = []
    @Published var userAccelerationXData: [Double] = []
    @Published var userAccelerationYData: [Double] = []
    @Published var userAccelerationZData: [Double] = []
    
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
                
                // データを追加
                self.rollData.append(self.roll)
                self.pitchData.append(self.pitch)
                self.yawData.append(self.yaw)
                self.gravityXData.append(self.rotation_x)
                self.gravityYData.append(self.rotation_y)
                self.gravityZData.append(self.rotation_z)
                self.rotationXData.append(self.rotation_x)
                self.rotationYData.append(self.rotation_y)
                self.rotationZData.append(self.rotation_z)
                self.userAccelerationXData.append(self.acc_x)
                self.userAccelerationYData.append(self.acc_y)
                self.userAccelerationZData.append(self.acc_z)

                // データ量を制限する場合（例：100データ）
                if self.rollData.count > 100 {
                    self.rollData.removeFirst()
                }
                if self.pitchData.count > 100 {
                    self.pitchData.removeFirst()
                }
                if self.yawData.count > 100 {
                    self.yawData.removeFirst()
                }
                if self.gravityXData.count > 100 {
                    self.gravityXData.removeFirst()
                }
                if self.gravityYData.count > 100 {
                    self.gravityYData.removeFirst()
                }
                if self.gravityZData.count > 100 {
                    self.gravityZData.removeFirst()
                }
                if self.rotationXData.count > 100 {
                    self.rotationXData.removeFirst()
                }
                if self.rotationYData.count > 100 {
                    self.rotationYData.removeFirst()
                }
                if self.rotationZData.count > 100 {
                    self.rotationZData.removeFirst()
                }
                if self.userAccelerationXData.count > 100 {
                    self.userAccelerationXData.removeFirst()
                }
                if self.userAccelerationYData.count > 100 {
                    self.userAccelerationYData.removeFirst()
                }
                if self.userAccelerationZData.count > 100 {
                    self.userAccelerationZData.removeFirst()
                }
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

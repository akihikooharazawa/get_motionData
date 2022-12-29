//
//  ContentView.swift
//  get_motion_v1.1 Watch App
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI
import CoreMotion
import WatchConnectivity

struct ContentView: View {
    
    var runtimeSession = WKExtendedRuntimeSession() // このセッションを使うことで1Hzになることを延長する
    var viewModel = ViewModel()
    let filePath = ViewModel.makeFilePath()
    let writer = MotionWriter() //Writerのインスタンス化
    let motionManager = CMMotionManager() //CMMotionManagerのインスタンス化
    let queue = OperationQueue()
    let formatter = DateFormatter()

    
    var body: some View {
        VStack {
            Button(action: {
                print("START")
                runtimeSession.start() //session start (Session to avoid 1Hz refresh rate)
                writer.open(filePath)
                self.startQueuedUpdates()
            }, label: {
                Text("Start")
                    .bold()
                    .foregroundColor(.green)
            })
            
            Button(action: {
                self.motionManager.stopDeviceMotionUpdates()
                writer.close()
                if (WCSession.default.isReachable) {
                    viewModel.session.transferFile(filePath, metadata: nil)
                }
                print("STOP")
            }, label: {
                Text("Stop")
                    .bold()
                    .foregroundColor(.red)
            })
        }
    }
    
    func startQueuedUpdates() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: self.queue, withHandler: { (data, error) in
                if let data = data {
                    writer.write(data)
                }
                if let error = error {
                    print(error)
                }
                if let validData = data {
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // ISO8601 style
                    /*
                    let timestamp = formatter.string(from: Date())
                    // 姿勢角(Attitude)
                    let roll = validData.attitude.roll
                    let pitch = validData.attitude.pitch
                    let yaw = validData.attitude.yaw
                    // 重力加速度(Gravity)
                    let gravity_x = validData.gravity.x
                    let gravity_y = validData.gravity.y
                    let gravity_z = validData.gravity.z
                    // 回転率(RotationRate)
                    let rotation_x = validData.rotationRate.x
                    let rotation_y = validData.rotationRate.y
                    let rotation_z = validData.rotationRate.z
                    // 加速度(Acceleration)
                    let accx = validData.userAcceleration.x
                    let accy = validData.userAcceleration.y
                    let accz = validData.userAcceleration.z
                    
                    // 表示用の文字列を作成する
                    let csvString = "time,roll,pitch,yaw,graX,graY,graZ,roX,roY,roZ,accX,accY,accZ\n"
                    + "\(timestamp),\(roll),\(pitch),\(yaw),\(gravity_x),\(gravity_y),\(gravity_z),\(rotation_x),\(rotation_y),\(rotation_z),\(accx),\(accy),\(accz)\n"
                    let csvStringData = csvString.data(using: .utf8)! //Data型に変換
                    viewModel.session.sendMessageData(csvStringData, replyHandler: nil)
                    */
                    //ここを追加
                    let message: [String: Any] = [
                        "timestamp": formatter.string(from: Date()),
                        "attitude_pitch": validData.attitude.pitch,
                        "attitude_roll": validData.attitude.roll,
                        "attitude_yaw": validData.attitude.yaw,
                        "gravity_x": validData.gravity.x,
                        "gravity_y": validData.gravity.y,
                        "gravity_z": validData.gravity.z,
                        "rotation_x": validData.rotationRate.x,
                        "rotation_y": validData.rotationRate.y,
                        "rotation_z": validData.rotationRate.z,
                        "acceleration_x": validData.userAcceleration.x,
                        "acceleration_y": validData.userAcceleration.y,
                        "acceleration_z": validData.userAcceleration.z
                    ]
                    viewModel.session.sendMessage(message,
                                                  replyHandler: { (reply) in do {
                        //print(message)
                    }},
                                                  errorHandler: { (error) in do {
                        print(error)
                    }})
                }
            })
        }
    }
} // MARK: iphone側にもデータを出したい。データを可視化させたい.

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

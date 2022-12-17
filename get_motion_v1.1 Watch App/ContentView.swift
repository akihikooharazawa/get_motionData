//
//  ContentView.swift
//  get_motion_v1.1 Watch App
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI
import CoreMotion
import WatchConnectivity // iphone側にデータを送信する

struct ContentView: View {
    
    var session = WKExtendedRuntimeSession() // このセッションを使うことで1Hzになることを延長する
    var wcSession: WCSession // お試し
    let motionManager = CMMotionManager() //CMMotionManagerのインスタンス化
    let queue = OperationQueue()
    let url = FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask).first! //Documentsディレクトリのパスを取得 (FileManagaerを使っているのでURL型)
    let formatter = DateFormatter()
    let writer = MotionWriter() //書き込み用classをインスタンス化
    
    // varから始まるのはプロパティ
    var body: some View {
        
        
        VStack {
            Button(action: {
                print("START")
                session.start() //session start (Session to avoid 1Hz refresh rate)
                writer.open(filePath: url) //想定しているデータ型はfilePathにURL型が格納されている状態
                self.startQueuedUpdates()
            }, label: {
                Text("Start")
                    .bold()
                    .foregroundColor(.green)
            })
            Button(action: {
                self.motionManager.stopDeviceMotionUpdates()
                print("STOP")
                writer.close()
            }, label: {
                Text("Stop")
                    .bold()
                    .foregroundColor(.red)
            })
        }
    } // varここまで
    
    func startQueuedUpdates() {
       if motionManager.isDeviceMotionAvailable {
           self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
           self.motionManager.showsDeviceMovementDisplay = true
           self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                                to: self.queue,
                                                withHandler: { (data, error) in
               if let data = data {
                   writer.write(motion: data)
               }
               if let error = error {
                   print(error)
               }
               
               // Make sure the data is valid before accessing it.
               if let validData = data {
                   formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // TimeStampの生成. ISO8601の拡張形式に則る
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
                   print(csvString)
               }
            })
        }
    } //funcここまで
    
   
} // MARK: データを可視化させたい.

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
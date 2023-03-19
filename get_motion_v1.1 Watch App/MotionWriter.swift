//
//  MotionWriter.swift
//  get_motion_v1.1 Watch App
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import Foundation
import CoreMotion

class MotionWriter {
    
    private var file: FileHandle?
    private var sample: Int = 0
    private let formatter = ISO8601DateFormatter()
    
    func open(_ filePath: URL) {
        FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        
        do {
            let file = try FileHandle(forWritingTo: filePath)
            let header = "timestamp,attitude_pitch,attitude_roll,attitude_yaw,gravity_x,gravity_y,gravity_z,rotation_x,rotation_y,rotation_z,acceleration_x,acceleration_y,acceleration_z\n"
            try file.write(contentsOf: header.data(using: .utf8)!)
            self.file = file
        } catch {
            print(error)
        }
    }
    func write(_ motion: CMDeviceMotion) {
        guard let file = self.file else { return }
        
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        
        let text = "\(timestamp),\(motion.attitude.pitch),\(motion.attitude.roll),\(motion.attitude.yaw),\(motion.gravity.x),\(motion.gravity.y),\(motion.gravity.z),\(motion.rotationRate.x),\(motion.rotationRate.y),\(motion.rotationRate.z),\(motion.userAcceleration.x),\(motion.userAcceleration.y),\(motion.userAcceleration.z)\n"
        /*
        var text = ""
        text += "\(timestamp),"
        text += "\(motion.attitude.pitch),"
        text += "\(motion.attitude.roll),"
        text += "\(motion.attitude.yaw),"
        text += "\(motion.gravity.x),"
        text += "\(motion.gravity.y),"
        text += "\(motion.gravity.z),"
        text += "\(motion.rotationRate.x),"
        text += "\(motion.rotationRate.y),"
        text += "\(motion.rotationRate.z),"
        text += "\(motion.userAcceleration.x),"
        text += "\(motion.userAcceleration.y),"
        text += "\(motion.userAcceleration.z),"
        text += "\n"
         */
        
        do {
            try file.write(contentsOf: text.data(using: .utf8)!)
        } catch {
            print(error)
        }
        sample += 1
    }
    
    func close() {
        guard let file = self.file else { return }
        file.closeFile()
        print("\(sample) sample")
        self.file = nil
    }
}

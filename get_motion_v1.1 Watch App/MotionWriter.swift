//
//  MotionWriter.swift
//  get_motion_v1.1 Watch App
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import Foundation
import CoreMotion

class MotionWriter {
    
    var file: FileHandle?
    var sample: Int = 0
    //let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let formatter = DateFormatter()
    //var viewModel = ViewModel()
    
    func open(_ filePath: URL) {
        do {
            FileManager.default.createFile(atPath: filePath.path,
                                           contents: nil,
                                           attributes: nil)
            
            let file = try FileHandle(forWritingTo: filePath)
            var header = ""
            header += "timestamp,"
            header += "attitude_pitch,"
            header += "attitude_roll,"
            header += "attitude_yaw,"
            header += "gravity_x,"
            header += "gravity_y,"
            header += "gravity_z,"
            header += "rotation_x,"
            header += "rotation_y,"
            header += "rotation_z,"
            header += "acceleration_x,"
            header += "acceleration_y,"
            header += "acceleration_z,"
            header += "\n"
            do {
                try file.write(contentsOf: header.data(using: .utf8)!)
            } catch let error {
                print(error)
            } //Data write to the file
            self.file = file
            print("Create file!")
        } catch let error {
            print(error)
        }
    }
    
    func write(_ motion: CMDeviceMotion) {
        guard let file = self.file else { return }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        
        var text = ""
        text += "\(timestamp)"
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
        print(text)
        do {
            try file.write(contentsOf: text.data(using: .utf8)!)
        } catch let error {
            print(error)
        } // Data write
        sample += 1
    }
    
    func close() {
        guard let file = self.file else { return }
        file.closeFile()
        print("\(sample) sample")
        self.file = nil
    }
}

import SwiftUI
import CoreMotion
import WatchConnectivity

struct ContentView: View {
    
    @State var roll: String = ""
    @State var pitch: String = ""
    @State var yaw: String = ""
    @State var gravity_x: String = ""
    @State var gravity_y: String = ""
    @State var gravity_z: String = ""
    @State var rotation_x: String = ""
    @State var rotation_y: String = ""
    @State var rotation_z: String = ""
    @State var accx: String = ""
    @State var accy: String = ""
    @State var accz: String = ""
    
    var runtimeSession = WKExtendedRuntimeSession() // Session to avoid 1Hz refresh rate
    var viewModel = WatchViewModel()
    let filePath = WatchViewModel.makeFilePath()
    let writer = MotionWriter()
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let formatter = DateFormatter()
    
    var body: some View {
        ScrollView {
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

                // 姿勢角(Attitude)
                Text("Attitude")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(roll)
                    Text(pitch)
                    Text(yaw)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.cyan)
                // 重力加速度(Gravity)
                Text("Gravity")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(gravity_x)
                    Text(gravity_y)
                    Text(gravity_z)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.cyan)
                // 回転率(RotationRate)
                Text("RotationRate")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(rotation_x)
                    Text(rotation_y)
                    Text(rotation_z)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.cyan)
                // 加速度(Acceleration)
                Text("Acceleration")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(accx)
                    Text(accy)
                    Text(accz)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.cyan)
                
                Button(action: {
                    self.motionManager.stopDeviceMotionUpdates()
                    writer.close()
                    viewModel.session.transferFile(filePath, metadata: nil)
                    print("STOP")
                }, label: {
                    Text("Stop")
                        .bold()
                        .foregroundColor(.red)
                })
                
            }
        }
    }
    
    func startQueuedUpdates() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: self.queue, withHandler: { (data, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {
                    return
                }
                writer.write(data)
                
                // 姿勢角(Attitude)
                self.roll = String(format: "%.2f", data.attitude.roll)
                self.pitch = String(format: "%.2f", data.attitude.pitch)
                self.yaw = String(format: "%.2f", data.attitude.yaw)
                // 重力加速度(Gravity)
                self.gravity_x = String(format: "%.2f", data.gravity.x)
                self.gravity_y = String(format: "%.2f", data.gravity.y)
                self.gravity_z = String(format: "%.2f", data.gravity.z)
                // 回転率(RotationRate)
                self.rotation_x = String(format: "%.2f", data.rotationRate.x)
                self.rotation_y = String(format: "%.2f", data.rotationRate.y)
                self.rotation_z = String(format: "%.2f", data.rotationRate.z)
                // 加速度(Acceleration)
                self.accx = String(format: "%.2f", data.userAcceleration.x)
                self.accy = String(format: "%.2f", data.userAcceleration.y)
                self.accz = String(format: "%.2f", data.userAcceleration.z)
                
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // ISO8601 style
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

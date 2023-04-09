import SwiftUI
import CoreMotion
import WatchConnectivity

class ExtendedRuntimeSessionDelegate: NSObject, WKExtendedRuntimeSessionDelegate {

    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session started.")
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session will expire.")
    }

    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("Extended runtime session did invalidate with reason: \(reason)")
    }
}

struct ContentView: View {
    
    @State private var roll: String = ""
    @State private var pitch: String = ""
    @State private var yaw: String = ""
    @State private var gravity_x: String = ""
    @State private var gravity_y: String = ""
    @State private var gravity_z: String = ""
    @State private var rotation_x: String = ""
    @State private var rotation_y: String = ""
    @State private var rotation_z: String = ""
    @State private var accx: String = ""
    @State private var accy: String = ""
    @State private var accz: String = ""
    
    private let extendedRuntimeSessionDelegate = ExtendedRuntimeSessionDelegate()
    private let runtimeSession = WKExtendedRuntimeSession() // Session to avoid 1Hz refresh rate
    private let viewModel = WatchViewModel()
    private let filePath = WatchViewModel.makeFilePath()
    private let writer = MotionWriter()
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private let formatter = DateFormatter()
    
    @State private var currentDeviceMotion: CMDeviceMotion?
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: startSession, label: {
                    Text("Start")
                        .bold()
                        .foregroundColor(.green)
                }) // ボタンアクション: Start
                createSensorView(title: "Attitude", values: [$roll, $pitch, $yaw])
                createSensorView(title: "Gravity", values: [$gravity_x, $gravity_y, $gravity_z])
                createSensorView(title: "RotationRate", values: [$rotation_x, $rotation_y, $rotation_z])
                createSensorView(title: "Acceleration", values: [$accx, $accy, $accz])
                Button(action: stopSession, label: {
                    Text("Stop")
                        .bold()
                        .foregroundColor(.red)
                }) // ボタンアクション: Stop
            }
        }
    }
    
    // ボタンアクションで動作する部分(Start)
    private func startSession() {
        print("START")
        runtimeSession.delegate = extendedRuntimeSessionDelegate
        runtimeSession.start() // バックグラウンドでも動作するようにする
        writer.open(filePath) // Dataの書き込み
        startMotionUpdates()
    }
    
    // ボタンアクションで動作する部分(Stop)
    private func stopSession() {
        stopMotionUpdates()
        writer.close()
        viewModel.session.transferFile(filePath, metadata: nil)
        print("STOP")
    }
    
    // MotionDataを取得し、writerを用いて書き込み、sendMessageDataでiphoneに送信
    private func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
            //motionManager.showsDeviceMovementDisplay = true
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: self.queue, withHandler: { (data, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {
                    return
                }
                self.currentDeviceMotion = data // 追加
                writer.write(data)
                DispatchQueue.main.async {
                    self.updateMotionValues(from: data)
                }
                self.sendMessageData(data: data)
            })
        }
    }
    
    private func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    // Apple Watchの画面にMotionDataを表示する
    private func createSensorView(title: String, values: [Binding<String>]) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(values[0].wrappedValue)
                Text(values[1].wrappedValue)
                Text(values[2].wrappedValue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.cyan)
        }
    }
    
    // CMDeviceMotionからデータを取得する
    private func updateMotionValues(from data: CMDeviceMotion) {
        roll = String(format: "%.2f", data.attitude.roll)
        pitch = String(format: "%.2f", data.attitude.pitch)
        yaw = String(format: "%.2f", data.attitude.yaw)
        gravity_x = String(format: "%.2f", data.gravity.x)
        gravity_y = String(format: "%.2f", data.gravity.y)
        gravity_z = String(format: "%.2f", data.gravity.z)
        rotation_x = String(format: "%.2f", data.rotationRate.x)
        rotation_y = String(format: "%.2f", data.rotationRate.y)
        rotation_z = String(format: "%.2f", data.rotationRate.z)
        accx = String(format: "%.2f", data.userAcceleration.x)
        accy = String(format: "%.2f", data.userAcceleration.y)
        accz = String(format: "%.2f", data.userAcceleration.z)
    }
    
    // データを送る
    private func sendMessageData(data: CMDeviceMotion) {
        if self.viewModel.session.isReachable {
            let messages: [String: Any] = ["attitude": ["roll": data.attitude.roll,
                                                        "pitch": data.attitude.pitch,
                                                        "yaw": data.attitude.yaw],
                                           "gravity": ["x": data.gravity.x,
                                                       "y": data.gravity.y,
                                                       "z": data.gravity.z],
                                           "rotationRate": ["x": data.rotationRate.x,
                                                            "y": data.rotationRate.y,
                                                            "z": data.rotationRate.z],
                                           "userAcceleration": ["x": data.userAcceleration.x,
                                                                "y": data.userAcceleration.y,
                                                                "z": data.userAcceleration.z]]

            self.viewModel.session.sendMessage(messages, replyHandler: { (reply) in
                //print("Pass Here")
            }, errorHandler: { (error) in
                print(error)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

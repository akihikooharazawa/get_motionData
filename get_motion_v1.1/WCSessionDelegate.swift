//
//  WCSessionDelegate.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/17.
//

import Foundation
import WatchConnectivity

final class ViewModel: NSObject {
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension ViewModel: WCSessionDelegate {
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
    
    // iphoneで受信
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        
        print(file)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = url.appendingPathComponent(file.fileURL.lastPathComponent)
        try! FileManager.default.copyItem(at: file.fileURL, to:dest)
        print(dest)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // メインスレッドで処理
        DispatchQueue.main.async {
            let receivedAnimal = message["animal"] as? String ?? "UMA"
            let receivedEmoji = message["emoji"] as? String ?? "❓"
            print(receivedEmoji + receivedAnimal)  // 🐱ネコ
        }
    }
}

//
//  WCSessionDelegate.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/17.
//

import Foundation
import WatchConnectivity

final class ViewModel: NSObject {
    
    let formatter = DateFormatter()
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    //おためし
    static func getDocumentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func makeFilePath() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let filename = formatter.string(from: Date()) + ".csv"
        let filePath = url.appendingPathComponent(filename)
        print(filePath.absoluteURL)
        return filePath
    }
}

extension ViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
    // iphonで受信するときのセッション
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("iphone",file)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = url.appendingPathComponent(file.fileURL.lastPathComponent)
        try! FileManager.default.copyItem(at: file.fileURL, to:dest)
        print("dest:", dest)
    }
}

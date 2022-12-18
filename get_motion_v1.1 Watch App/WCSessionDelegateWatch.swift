//
//  WCSessionDelegateWatch.swift
//  get_motion_v1.1 Watch App
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
    /*static func getDocumentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    } */
    
    /*static func makeFilePath() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let filename = formatter.string(from: Date()) + ".csv"
        let filePath = url.appendingPathComponent(filename)
        return filePath
    } */
}

extension ViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Watch session has activated!!")
        }
    }
}



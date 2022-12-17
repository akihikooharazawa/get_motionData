//
//  ContentView.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var body: some View {
        
        //追加
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI
//import WatchConnectivity

struct ContentView: View {
    //@State private var message = ""
    
    var viewModel = ViewModel()
    
    @State private var isReachable = "NO"

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        // true の場合メッセージ送信可能
                        self.isReachable = self.viewModel.session.isReachable ? "YES": "NO"
                    }) {
                        Text("Check")
                    }
                    .padding(.leading, 16.0)
                    Spacer()
                    Text("isReachable")
                        .font(.headline)
                        .padding()
                    Text(self.isReachable)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding()
                }
                .background(Color.init(.systemGray5))
                Spacer()
            }
            .navigationTitle("Receiver")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

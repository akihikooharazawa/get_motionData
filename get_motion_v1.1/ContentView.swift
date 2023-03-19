//
//  ContentView.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State private var isReachable = "NO"
    
    var body: some View {
        NavigationView {
            VStack {
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

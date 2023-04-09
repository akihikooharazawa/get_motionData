//
//  get_motion_v1_1App.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI

@main
struct get_motion_v1_1App: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}

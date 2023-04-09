//
//  ContentView.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("Attitude")
            HStack {
                Text("Roll: \(String(format: "%.2f", viewModel.roll))")
                Text("Pitch: \(String(format: "%.2f", viewModel.pitch))")
                Text("Yaw: \(String(format: "%.2f", viewModel.yaw))")
            }
            .foregroundColor(.cyan)
            
            Text("Gravity")
            HStack {
                Text("X: \(String(format: "%.2f", viewModel.gravity_x))")
                Text("Y: \(String(format: "%.2f", viewModel.gravity_y))")
                Text("Z: \(String(format: "%.2f", viewModel.gravity_z))")
            }
            .foregroundColor(.green)

            Text("Rotation Rate")
            HStack {
                Text("X: \(String(format: "%.2f", viewModel.rotation_x))")
                Text("Y: \(String(format: "%.2f", viewModel.rotation_y))")
                Text("Z: \(String(format: "%.2f", viewModel.rotation_z))")
            }
            .foregroundColor(.orange)

            Text("User Acceleration")
            HStack {
                Text("X: \(String(format: "%.2f", viewModel.acc_x))")
                Text("Y: \(String(format: "%.2f", viewModel.acc_y))")
                Text("Z: \(String(format: "%.2f", viewModel.acc_z))")
            }
            .foregroundColor(.purple)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}

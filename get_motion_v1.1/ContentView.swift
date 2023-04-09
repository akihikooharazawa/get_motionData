//
//  ContentView.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/16.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    // LineGraph Shapeの定義を追加
    struct LineGraph: Shape {
        let data: [Double]
        let minValue: Double
        let maxValue: Double

        func path(in rect: CGRect) -> Path {
            var path = Path()
            guard data.count > 1 else { return path }

            let xInterval = rect.width / CGFloat(data.count - 1)

            let range = maxValue - minValue
            let scaleY = range > 0 ? rect.height / CGFloat(range) : 0

            path.move(to: CGPoint(x: 0, y: rect.height - CGFloat(data[0] - minValue) * scaleY))
            for index in 1..<data.count {
                let xPosition = CGFloat(index) * xInterval
                let yPosition = rect.height - CGFloat(data[index] - minValue) * scaleY
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            }
            return path
        }
    }

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
            
            Text("User Acceleration X")
            LineGraph(data: viewModel.userAccelerationXData, minValue: -1, maxValue: 1)
                .stroke(Color.purple, lineWidth: 1)
                .frame(height: 200)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}

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
    let test = "0.00001" //とりあえず仮置き
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.isReachable = viewModel.session.isReachable ? "YES": "NO"
                    }) {
                        Text("Check")
                    }
                    .padding(.leading, 13.0)
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
                
                VStack {
                    HStack {
                        Text("Time")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(viewModel.message_time)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("attitude_pitch")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(viewModel.message_attitude_pitch)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("attitude_roll")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(viewModel.message_time)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("attitude_yaw")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(viewModel.message_time)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("gravity_x")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(test)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("gravity_y")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(test)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("gravity_z")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(test)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("rotation_x")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(test)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("rotation_y")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(test)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                    HStack {
                        Text("rotation_z")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 20.0)
                        Spacer()
                        Text(test)
                            .foregroundColor(Color.red)
                            .padding(.trailing, 50.0)
                    }
                }
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

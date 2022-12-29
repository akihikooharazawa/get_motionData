//
//  DistRow.swift
//  get_motion_v1.1
//
//  Created by OharazawaAkihiko on 2022/12/27.
//

import Foundation
import SwiftUI

struct MessageRow: View {
    let message: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(message)
                .font(.body)
                .padding(.vertical, 4.0)
        }
    }
}

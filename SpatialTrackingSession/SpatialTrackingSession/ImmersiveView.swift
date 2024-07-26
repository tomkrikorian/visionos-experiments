//
//  ImmersiveView.swift
//  SpatialTrackingSession
//
//  Created by Tom Krikorian on 26/07/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        RealityView { _ in
        }
        .task {
            await appModel.runSession()
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}

//
//  ContentView.swift
//  SpatialTrackingSession
//
//  Created by Tom Krikorian on 26/07/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack {
            Text("SpatialTrackingSession")
                .font(.title)
                .padding()
            
            List {
                ForEach(Array(appModel.trackingSupport.keys.sorted(by: { "\($0)" < "\($1)" })), id: \.self) { capability in
                    TrackingStateRow(title: String(describing: capability),
                                     state: appModel.trackingSupport[capability] ?? .unknown)
                }
            }
            .listStyle(InsetGroupedListStyle())

            ToggleImmersiveSpaceButton()
                .padding()
        }
        .padding()
        .task {
            await appModel.runSession()
        }
    }
}

struct TrackingStateRow: View {
    let title: String
    let state: AppModel.TrackingSupport
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(stateEmoji)
        }
    }
    
    private var stateEmoji: String {
        switch state {
        case .supported:
            return "✅"
        case .notSupported:
            return "❌"
        case .unknown:
            return "❓"
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

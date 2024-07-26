//
//  AppModel.swift
//  SpatialTrackingSession
//
//  Created by Tom Krikorian on 26/07/2024.
//

import SwiftUI
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState { case closed, inTransition, open }
    enum TrackingSupport { case supported, notSupported, unknown }
    
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var trackingSupport: [SpatialTrackingSession.Configuration.AnchorCapability: TrackingSupport] = [
        .hand: .unknown, .image: .unknown, .object: .unknown, .plane: .unknown, .world: .unknown
    ]
    
    func runSession() async {
        let configuration = SpatialTrackingSession.Configuration(tracking: Set(trackingSupport.keys))
        let session = SpatialTrackingSession()
        
        if let unavailableCapabilities = await session.run(configuration) {
            for capability in trackingSupport.keys {
                trackingSupport[capability] = unavailableCapabilities.anchor.contains(capability) ? .notSupported : .supported
                if trackingSupport[capability] == .notSupported {
                    print("\(capability) tracking is not supported by the device")
                }
            }
        } else {
            trackingSupport = trackingSupport.mapValues { _ in .supported }
        }
    }
}

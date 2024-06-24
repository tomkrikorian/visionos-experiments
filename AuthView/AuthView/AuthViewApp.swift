//
//  AuthViewApp.swift
//  AuthView
//
//  Created by Tom Krikorian on 24/06/2024.
//

import SwiftUI

@main
struct AuthViewApp: App {
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
        .defaultSize(CGSize(width: 1024, height: 768))
    }
}

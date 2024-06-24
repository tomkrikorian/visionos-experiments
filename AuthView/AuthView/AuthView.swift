//
//  ContentView.swift
//  AuthView
//
//  Created by Tom Krikorian on 24/06/2024.
//

import SwiftUI
import AuthenticationServices
import MapKit
import AVFoundation

struct Location: Hashable {
    let coordinate: CLLocationCoordinate2D

    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct AuthView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var position : MapCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: .infinity))
    @State private var appear = false
    @State private var audioPlayer: AVAudioPlayer?
    
    let locations = [
        Location(coordinate: CLLocationCoordinate2D(latitude: -1.2833, longitude: 36.8167)), // Nairobi, Kenya
        Location(coordinate: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)), // Tokyo, Japan
        Location(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)), // Paris, France
        Location(coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)), // New York City, USA
        Location(coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)) // Sydney, Australia
    ]

    var body: some View {
        ZStack {
            Map(initialPosition: position, interactionModes: [.rotate, .pan]) {
                ForEach(locations, id: \.self) { location in
                    Annotation("Marker", coordinate: location.coordinate) {
                        VStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                )
                        }
                    }
                    .annotationTitles(.hidden)
                }
            }
            .mapStyle(.imagery(elevation: .realistic))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                playSound()
            }
            VStack(alignment: .center) {
                Text("AuthView Experiment")
                    .font(.system(size: 50, weight: .bold))
                    .scaleEffect(appear ? 1 : 0.95)
                    .opacity(appear ? 1 : 0.85)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: appear)
                    .onAppear {
                        self.appear = true
                    }
                    .frame(width: .infinity)
                Spacer()
                SignInWithAppleButton(
                    onRequest: { request in
                    },
                    onCompletion: { result in
                    }
                )
                .frame(width: 150, height: 44)
                .colorInvert()
            }
            .frame(width: .infinity, height: 400)
            .frame(depth: 25)
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "wow", withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AuthView()
}

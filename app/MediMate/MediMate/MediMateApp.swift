//
//  MediMateApp.swift
//  MediMate
//
//  Created by Simon Bestler on 09.05.25.
//

import SwiftUI
import SwiftData
import LiveKit
import LiveKitComponents

@main
struct MediMateApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // Switch between onboarding and old ContentView for testing
            //OnboardingFlowView()
            // ContentView() // Uncomment to use the old ContentView
            AvatarView()
            //RoomScope(roomOptions: RoomOptions(defaultAudioCaptureOptions: Audi)) {
               // VideoConferenceView()
            //}
        }
        .modelContainer(sharedModelContainer)
    }
}

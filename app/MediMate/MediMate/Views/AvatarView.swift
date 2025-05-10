//
//  AvatarView.swift
//  MediMate
//
//  Created by Simon Bestler on 10.05.25.
//

import SwiftUI
import LiveKit
import LiveKitComponents
import AVFAudio


struct AvatarView: View {
    let wsURL = "wss://medimate-ffsfrtuw.livekit.cloud"
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDY5OTM2MDYsImlzcyI6IkFQSVJVUHprckFFUmpvRyIsIm5hbWUiOiJqb25hcyIsIm5iZiI6MTc0NjkwNzIwNiwic3ViIjoiam9uYXMiLCJ2aWRlbyI6eyJyb29tIjoiZmFrZV9yb29tIiwicm9vbUpvaW4iOnRydWV9fQ.DIJXAu4KnAQzc9PBSHcl9FCKvK0scnS5XGGMKW7Qzac"
    // In production you should generate tokens on your server, and your client
    // should request a token from your server.

    var body: some View {
        RoomScope(url: wsURL, token: token, connect: true, enableCamera: true, enableMicrophone: true) {
            ScrollView {
                LazyVStack {
                    ForEachParticipant { participant in
                        VStack {
                            if (participant.identity?.description == "bey-avatar-agent") {
                                ForEachTrack(filter: .video) { trackReference in
                                    VideoTrackView(trackReference: trackReference)
                                }
                            }
                        }
                        .padding()
                        .border(Color.gray)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AvatarView()
}

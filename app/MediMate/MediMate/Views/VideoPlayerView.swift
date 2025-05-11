import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: View {
    let videoURL: URL
    @State private var player: AVPlayer?
    @State private var isVideoFinished = false
    // Add an ID property to force view recreation when the view changes
    let id: UUID
    
    init(url: URL) {
        self.videoURL = url
        self.id = UUID() // Generate a unique ID each time
        _player = State(initialValue: AVPlayer(url: videoURL))
        
        // Configure audio session to play even in silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    var body: some View {
        Group {
            if !isVideoFinished {
                VideoPlayer(player: player)
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .disabled(true) // Disables user interaction with the player
                    .onAppear() {
                        // Configure player for autoplay
                        player?.isMuted = false
                        player?.play()
                        
                        // Add observer to hide video when it ends
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player?.currentItem,
                            queue: .main
                        ) { _ in
                            isVideoFinished = true
                        }
                    }
            }
        }
            .onDisappear() {
                // Clean up
                player?.pause()
                NotificationCenter.default.removeObserver(
                    self,
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem
                )
                
                // Deactivate audio session
                /*
                do {
                    try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
                } catch {
                    print("Failed to deactivate audio session: \(error)")
                }
                 */
            }
    }
}

// Helper initializer that takes a string URL and converts it to URL object
extension VideoPlayerView {
    init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            return nil
        }
        self.init(url: url)
    }
}

#Preview {
    // Example preview with a sample video
    if let sampleURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") {
        return VideoPlayerView(url: sampleURL)
    } else {
        return Text("Invalid URL")
    }
}

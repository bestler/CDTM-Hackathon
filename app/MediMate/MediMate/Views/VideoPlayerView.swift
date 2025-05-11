import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: URL
    @State private var player: AVPlayer?
    
    init(url: URL) {
        self.videoURL = url
        _player = State(initialValue: AVPlayer(url: videoURL))
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            .disabled(true) // Disables user interaction with the player
            .onAppear() {
                // Configure player for autoplay
                player?.isMuted = false
                player?.play()
                
                // Add observer to replay video when it ends
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem,
                    queue: .main
                ) { _ in
                    player?.seek(to: CMTime.zero)
                    player?.play()
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

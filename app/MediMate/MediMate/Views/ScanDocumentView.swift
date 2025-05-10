import SwiftUI

struct ScanDocumentView: View {
    @ObservedObject var viewModel: ScanDocumentViewModel
    
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var showDocumentPicker = false

    var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 12) {
                // Full width camera button
                Button(action: { showCamera = true }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Scan with Camera")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                // Side-by-side buttons for Photo Library and Files
                HStack(spacing: 8) {
                    // Photo Library Button (50% width)
                    Button(action: { showPhotoLibrary = true }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Photo Library")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    // Files Button (50% width)
                    Button(action: { showDocumentPicker = true }) {
                        HStack {
                            Image(systemName: "doc")
                            Text("Files (PDF)")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }

            // Preview
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(viewModel.selectedImages.enumerated()), id: \ .offset) { idx, image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(8)
                                Button(action: {
                                    viewModel.selectedImages.remove(at: idx)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .padding(4)
                            }
                        }
                    }
                }
            }
            if !viewModel.selectedFileURLs.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(viewModel.selectedFileURLs.enumerated()), id: \ .offset) { idx, url in
                            ZStack(alignment: .topTrailing) {
                                Text(url.lastPathComponent)
                                    .frame(width: 120, height: 120)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                Button(action: {
                                    viewModel.selectedFileURLs.remove(at: idx)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .padding(4)
                            }
                        }
                    }
                }
            }

            // Uploading and error state are now handled in the review step, not here.
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(images: $viewModel.selectedImages)
        }
        .sheet(isPresented: $showPhotoLibrary) {
            PhotoLibraryPicker(images: $viewModel.selectedImages)
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(fileURLs: $viewModel.selectedFileURLs)
        }
    }
}

import SwiftUI

struct ScanDocumentView: View {
    @ObservedObject var viewModel: ScanDocumentViewModel
    
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var showDocumentPicker = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Vaccination Document Upload")
                .font(.headline)

            VStack(spacing: 12) {
                Button(action: { showCamera = true }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Scan with Camera")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(action: { showPhotoLibrary = true }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Photo Library")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: { showDocumentPicker = true }) {
                    HStack {
                        Image(systemName: "doc")
                        Text("Files (PDF)")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
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

            if viewModel.isUploading {
                ProgressView("Uploading...")
            } else if viewModel.uploadResult == nil {
                Button("Upload & Continue") {
                    viewModel.uploadAndContinue()
                }
                .disabled(viewModel.selectedImages.isEmpty && viewModel.selectedFileURLs.isEmpty)
            }
            if let error = viewModel.uploadError {
                Text(error)
                    .foregroundColor(.red)
            }

            // Show review if uploadResult is available
            if let vaccination = viewModel.uploadResult {
                Divider().padding(.vertical, 8)
                Text("Extracted Vaccination Info")
                    .font(.subheadline)
                VaccinationReviewView(viewModel: .init())
            }
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

import SwiftUI

struct ScanDocumentView: View {
    @ObservedObject var viewModel: ScanDocumentViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Scan or Upload Medical Document")
                .font(.headline)
            Picker("Input Type", selection: $viewModel.inputType) {
                ForEach(InputType.allCases) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Preview
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(viewModel.selectedImages.enumerated()), id: \ .offset) { idx, image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .cornerRadius(8)
                        }
                    }
                }
            } else if !viewModel.selectedFileURLs.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(viewModel.selectedFileURLs.enumerated()), id: \ .offset) { idx, url in
                            Text(url.lastPathComponent)
                                .frame(width: 120, height: 120)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            if viewModel.isUploading {
                ProgressView("Uploading...")
            } else {
                Button("Upload & Continue") {
                    viewModel.uploadAndContinue()
                }
                .disabled(viewModel.selectedImages.isEmpty && viewModel.selectedFileURLs.isEmpty)
            }
            if let error = viewModel.uploadError {
                Text(error)
                    .foregroundColor(.red)
            }
        }
    }
}

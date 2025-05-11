import SwiftUI

struct GeneralInformationView: View {
    @ObservedObject var viewModel: GeneralInformationViewModel
    @State private var showingGeneralInfoModal = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Personal Information Document")
                    .font(.title2)
                    .padding(.top)
                
                if viewModel.generalInformation == nil {
                    Text("Upload your ID or other personal document by scanning with the camera, selecting from your photos, or choosing PDF files. Or you can manually enter your personal information.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                } else {
                    Text("Your personal information has been recorded. You can add more documents or edit your existing details.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
            }
            .padding(.horizontal)
            
            // ScanDocumentView is a child view
            ScanDocumentView(viewModel: viewModel.scanViewModel)
            
            if !viewModel.isUploading && viewModel.generalInformation == nil {
                // Only show the OR divider when not uploading and no general information exists
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("OR")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal)
                
                // Only show the manual entry button when not uploading
                Button(action: {
                    showingGeneralInfoModal = true
                    viewModel.isManualEntry = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Enter Information Manually")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            } else if !viewModel.isUploading && viewModel.generalInformation != nil {
                // Show edit button only when we have general information and not uploading
                Button(action: {
                    showingGeneralInfoModal = true
                    viewModel.isManualEntry = false
                }) {
                    HStack {
                        Image(systemName: "person.text.rectangle")
                        Text("Edit Information")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            
            if viewModel.isUploading {
                VStack {
                    ProgressView("Uploading and processing your document...")
                        .padding()
                    Text("Please wait while we analyze your personal information")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            if let error = viewModel.uploadError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Empty VStack just to observe changes
            VStack {}
                .onChange(of: viewModel.generalInformation != nil) { oldValue, newValue in
                    if newValue && !viewModel.isManualEntry && !viewModel.isUploading {
                        showingGeneralInfoModal = true
                    }
                }
                // This ensures the modal displays after uploading completes
                .onChange(of: viewModel.isUploading) { _, isUploading in
                    if !isUploading && viewModel.generalInformation != nil && !viewModel.isManualEntry {
                        // Show general information modal after upload finishes if we have info
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showingGeneralInfoModal = true
                        }
                    }
                }
                .onAppear {
                    if viewModel.generalInformation != nil && !viewModel.isManualEntry {
                        showingGeneralInfoModal = true
                    }
                }
        }
        .sheet(isPresented: $showingGeneralInfoModal, onDismiss: {
            // Ensure changes are saved when modal is dismissed
            viewModel.objectWillChange.send()
        }) {
            ExtractedGeneralInfoView(viewModel: viewModel)
        }
    }
}

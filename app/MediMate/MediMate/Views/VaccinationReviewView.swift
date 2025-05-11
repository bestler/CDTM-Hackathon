import SwiftUI

struct VaccinationReviewView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel
    @State private var showingVaccinationsModal = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Vaccination Documents")
                    .font(.title2)
                    //.padding(.top)

                if viewModel.vaccinations.isEmpty {
                    Text("Upload your vaccination documents by scanning with the camera, selecting from your photos, or choosing PDF files. Or you can manually enter your vaccination information.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                } else {
                    Text("\(viewModel.vaccinations.count) vaccination\(viewModel.vaccinations.count > 1 ? "s" : "") recorded. You can add more documents or edit your existing vaccinations.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
            }
            .padding(.horizontal)

            // ScanDocumentView is now a child of this view, using the scanViewModel from the reviewViewModel
            ScanDocumentView(viewModel: viewModel.scanViewModel)

            if !viewModel.isUploading && viewModel.vaccinations.isEmpty {
                // Only show the OR divider when not uploading and no vaccinations exist
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
                    showingVaccinationsModal = true
                    viewModel.isManualEntry = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Enter Vaccinations Manually")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            } else if !viewModel.isUploading && !viewModel.vaccinations.isEmpty {
                // Show edit button only when we have vaccinations and not uploading
                Button(action: {
                    showingVaccinationsModal = true
                    viewModel.isManualEntry = false
                }) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                        Text("Edit Vaccinations (\(viewModel.vaccinations.count))")
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
                    Text("Please wait while we analyze your vaccination information")
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
                .onChange(of: viewModel.vaccinations) { _, newVaccinations in
                    if !newVaccinations.isEmpty && !viewModel.isManualEntry && !viewModel.isUploading {
                        showingVaccinationsModal = true
                    }
                }
                // This ensures the modal displays after uploading completes
                .onChange(of: viewModel.isUploading) { _, isUploading in
                    if !isUploading && !viewModel.vaccinations.isEmpty && !viewModel.isManualEntry {
                        // Show vaccinations modal after upload finishes if we have vaccinations
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showingVaccinationsModal = true
                        }
                    }
                }
                .onAppear {
                    if !viewModel.vaccinations.isEmpty && !viewModel.isManualEntry {
                        showingVaccinationsModal = true
                    }
                }
        }
        .sheet(isPresented: $showingVaccinationsModal) {
            ExtractedVaccinationsView(viewModel: viewModel)
        }
    }
}

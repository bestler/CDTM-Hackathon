import SwiftUI

struct VaccinationReviewView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel
    @State private var showingVaccinationsModal = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Vaccination Documents")
                    .font(.title2)
                    .padding(.top)

                Text("Upload your vaccination documents by scanning with the camera, selecting from your photos, or choosing PDF files. Or you can manually enter your vaccination information.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
            }
            .padding(.horizontal)

            // ScanDocumentView is now a child of this view, using the scanViewModel from the reviewViewModel
            ScanDocumentView(viewModel: viewModel.scanViewModel)

            // Divider with "OR" text
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

            // Combined button for manual entry/edit based on whether vaccinations exist
            Button(action: {
                showingVaccinationsModal = true
                // Only set manual entry true if there are no vaccinations yet
                viewModel.isManualEntry = viewModel.vaccinations.isEmpty
            }) {
                HStack {
                    Image(systemName: viewModel.vaccinations.isEmpty ? "pencil" : "list.bullet.clipboard")
                    Text(viewModel.vaccinations.isEmpty ?
                         "Enter Vaccinations Manually" :
                            "Edit Vaccinations (\(viewModel.vaccinations.count))")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.vaccinations.isEmpty ? Color.secondary : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)

            if viewModel.isUploading {
                ProgressView("Uploading...")
            }
            if let error = viewModel.uploadError {
                Text(error)
                    .foregroundColor(.red)
            }

            // Empty VStack just to observe changes in vaccinations
            VStack {}
                .onChange(of: viewModel.vaccinations) { _, newVaccinations in
                    if !newVaccinations.isEmpty && !viewModel.isManualEntry {
                        showingVaccinationsModal = true
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

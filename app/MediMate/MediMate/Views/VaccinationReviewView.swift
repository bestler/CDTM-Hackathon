import SwiftUI

struct VaccinationReviewView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel
    @State private var showingVaccinationsModal = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Vaccination Documents")
                .font(.title2)
                .padding(.top)

            // ScanDocumentView is now a child of this view, using the scanViewModel from the reviewViewModel
            ScanDocumentView(viewModel: viewModel.scanViewModel)

            // Upload button
            Button(action: {
                viewModel.uploadAndParseVaccinations()
            }) {
                HStack {
                    Image(systemName: "arrow.up.doc")
                    Text("Upload & Parse Vaccinations")
                }
            }
            .buttonStyle(.borderedProminent)
            //.disabled((viewModel.selectedImages.isEmpty && viewModel.selectedFileURLs.isEmpty) || viewModel.isUploading)

            if viewModel.isUploading {
                ProgressView("Uploading...")
            }
            if let error = viewModel.uploadError {
                Text(error)
                    .foregroundColor(.red)
            }

            // Show a button but also trigger modal automatically when vaccinations are available
            if !viewModel.vaccinations.isEmpty {
                Button(action: {
                    showingVaccinationsModal = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                        Text("View Extracted Vaccinations (\(viewModel.vaccinations.count))")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .onAppear {
                    showingVaccinationsModal = true
                }
            }

            }
        .sheet(isPresented: $showingVaccinationsModal) {
            ExtractedVaccinationsView(viewModel: viewModel)
        }
    }
}

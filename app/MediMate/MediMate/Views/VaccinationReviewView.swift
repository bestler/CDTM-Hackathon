import SwiftUI

struct VaccinationReviewView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel

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

            if !viewModel.vaccinations.isEmpty {
                Text("Extracted Vaccinations")
                    .font(.headline)
                // Grid/List of vaccinations
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(Array(viewModel.vaccinations.enumerated()), id: \ .offset) { idx, vaccination in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Name", text: Binding(
                                    get: { vaccination.name },
                                    set: { newValue in
                                        var updated = vaccination
                                        updated = Vaccination(name: newValue, doctor: vaccination.doctor, date: vaccination.date)
                                        viewModel.updateVaccination(updated, at: idx)
                                    })
                                )
                                TextField("Doctor", text: Binding(
                                    get: { vaccination.doctor },
                                    set: { newValue in
                                        var updated = vaccination
                                        updated = Vaccination(name: vaccination.name, doctor: newValue, date: vaccination.date)
                                        viewModel.updateVaccination(updated, at: idx)
                                    })
                                )
                                TextField("Date", text: Binding(
                                    get: { vaccination.date },
                                    set: { newValue in
                                        var updated = vaccination
                                        updated = Vaccination(name: vaccination.name, doctor: vaccination.doctor, date: newValue)
                                        viewModel.updateVaccination(updated, at: idx)
                                    })
                                )
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}

import SwiftUI

struct VaccinationReviewView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel
    @StateObject var scanViewModel = ScanDocumentViewModel()

    var body: some View {
        VStack(spacing: 24) {
            // Document scan/upload section
            ScanDocumentView(viewModel: scanViewModel)

            // Only show review form if uploadResult is available
            if let vaccination = scanViewModel.uploadResult {
                Form {
                    Section(header: Text("Vaccination Data")) {
                        TextField("Vaccine Name", text: $viewModel.vaccineName)
                        TextField("Date", text: $viewModel.date)
                        TextField("Lot Number", text: $viewModel.lotNumber)
                        // Add more fields as needed
                    }
                }
            }
        }
        .onChange(of: scanViewModel.uploadResult) { newValue in
            // Prefill review fields when uploadResult changes
            viewModel.prefill(with: newValue)
        }
    }
}

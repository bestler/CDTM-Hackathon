import SwiftUI

struct VaccinationReviewView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel
    var body: some View {
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

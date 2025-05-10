import SwiftUI

struct HealthKitStepView: View {
    @ObservedObject var viewModel: HealthKitStepViewModel
    var body: some View {
        VStack(spacing: 20) {
            Text("Apple HealthKit Integration")
                .font(.headline)
            if !viewModel.isAuthorized {
                Button("Connect to Apple HealthKit") {
                    viewModel.requestHealthKit()
                }
            } else if !viewModel.isDataFetched {
                ProgressView("Fetching Health Data...")
            } else {
                if viewModel.isUploading {
                    ProgressView("Uploading Health Data...")
                } else {
                    Button("Send Health Data to API") {
                        viewModel.uploadHealthData()
                    }
                    .disabled(!viewModel.isDataFetched)
                }
                if let result = viewModel.uploadResult {
                    Text(result)
                        .font(.caption)
                        .foregroundColor(result.contains("successful") ? .green : .red)
                }
            }
        }
        .padding()
    }
}

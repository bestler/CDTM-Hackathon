import SwiftUI

struct HealthKitStepView: View {
    @ObservedObject var viewModel: HealthKitStepViewModel
    var body: some View {
        VStack(spacing: 20) {
            Text("Connect to Your Health Data")
                .font(.headline)
            if !viewModel.isAuthorized {
                Button("Connect to Health App") {
                    viewModel.requestHealthKit()
                }
                .buttonStyle(.borderedProminent)
            } else if !viewModel.isDataFetched || viewModel.isUploading {
                ProgressView(viewModel.isUploading ? "Preparing your health data..." : "Accessing your health records...")
            } else {
                // Show a processing indicator with no debug message
                Text("Your health data was successfully imported")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

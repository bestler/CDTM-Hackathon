import Foundation
import SwiftUI
import HealthKit

class HealthKitStepViewModel: ObservableObject, FlowStepViewModel {
    @Published var isAuthorized = false
    @Published var isUploading = false
    @Published var uploadResult: String? = nil
    @Published var isDataFetched = false
    let healthKitManager = HealthKitManager()
    var title: String { "Apple HealthKit" }
    var isComplete: Bool { true } // Always allow skipping

    func requestHealthKit() {
        healthKitManager.requestAuthorization { [weak self] success in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.fetchData()
                }
            }
        }
    }

    func fetchData() {
        self.isDataFetched = false
        healthKitManager.fetchAllData()
        // Wait for allData to be updated (since fetchAllData is async)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isDataFetched = true
        }
    }

    func uploadHealthData() {
        guard isDataFetched else { return }
        isUploading = true
        uploadResult = nil
        let appleHealth = healthKitManager.toAppleHealth()
        APIService.shared.uploadHealthData(appleHealth) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let msg):
                    self?.uploadResult = "Upload successful: \(msg)"
                case .failure(let error):
                    self?.uploadResult = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    func onNext(completion: @escaping (Bool) -> Void) {
        completion(isComplete)
    }
}

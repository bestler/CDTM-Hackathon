import Foundation
import SwiftUI
import HealthKit

class HealthKitStepViewModel: ObservableObject, FlowStepViewModel {
    func handleSave() {
        
    }
    
    @Published var isAuthorized = false
    @Published var isUploading = false
    @Published var uploadResult: String? = nil
    @Published var isDataFetched = false
    let healthKitManager = HealthKitManager()
    var title: String { "Import Health Data" }
    var isComplete: Bool { true } // Always allow skipping
    var isStaticVideo: Bool { true }
    var videoName: String { "apple_health" }

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
            // Automatically upload health data as soon as it's fetched
            self.uploadHealthData()
        }
    }

    func uploadHealthData(autoNavigate: Bool = true) {
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
                    if autoNavigate {
                        // Add a small delay to show the success message before navigating
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self?.triggerNavigation()
                        }
                    }
                case .failure(let error):
                    self?.uploadResult = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func triggerNavigation() {
        // Call onNext with completion handler to navigate to the next step
        onNext { _ in
            // Navigation is handled by the OnboardingFlowView
        }
    }

    func onNext(completion: @escaping (Bool) -> Void) {
        // If we've already completed the upload, navigate immediately
        if isDataFetched && !isUploading && uploadResult != nil {
            completion(true)
        } else if isAuthorized && !isUploading {
            // If authorized but not uploading, start upload and navigate after
            uploadHealthData(autoNavigate: false)
            // Add a delay to wait for upload to potentially complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(true)
            }
        } else {
            // Always allow skipping as per the original implementation
            completion(isComplete)
        }
    }
}

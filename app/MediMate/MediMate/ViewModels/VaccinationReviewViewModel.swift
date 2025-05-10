import Foundation
import SwiftUI



class VaccinationReviewViewModel: ObservableObject, FlowStepViewModel {
    // Upload state - declare these first
    @Published var isUploading: Bool = false
    @Published var uploadError: String? = nil
    @Published var vaccinations: [Vaccination] = []

    // ScanDocumentViewModel is now a child view model - declare after the basic properties
    @Published var scanViewModel: ScanDocumentViewModel

    // Computed properties after all stored properties
    var selectedImages: [UIImage] {
        get { scanViewModel.selectedImages }
        set { scanViewModel.selectedImages = newValue }
    }

    var selectedFileURLs: [URL] {
        get { scanViewModel.selectedFileURLs }
        set { scanViewModel.selectedFileURLs = newValue }
    }

    var title: String { "Review Vaccination" }
    var isComplete: Bool { !vaccinations.isEmpty }

    // Custom initializer
    init(scanViewModel: ScanDocumentViewModel = ScanDocumentViewModel()) {
        self.scanViewModel = scanViewModel
    }

    // Upload and parse vaccinations from API
    func uploadAndParseVaccinations() {
        isUploading = true
        uploadError = nil
        APIService.shared.uploadDocument(images: selectedImages, fileURLs: selectedFileURLs) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let responseString):
                    print(responseString)
                    // Try to decode [Vaccination] from responseString
                    if let data = responseString.data(using: .utf8),
                       let vaccinationsResponse = try? JSONDecoder().decode(VaccinationResponse.self, from: data) {
                        self?.vaccinations = vaccinationsResponse.data
                    } else {
                        self?.uploadError = "Failed to parse vaccinations."
                    }
                case .failure(let error):
                    self?.uploadError = error.localizedDescription
                }
            }
        }
    }

    // Optionally, allow editing a vaccination in the array
    func updateVaccination(_ vaccination: Vaccination, at index: Int) {
        guard vaccinations.indices.contains(index) else { return }
        vaccinations[index] = vaccination
    }

    func onNext(completion: @escaping (Bool) -> Void) {
        completion(isComplete)
    }
}

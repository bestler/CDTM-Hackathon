import Foundation
import SwiftUI



class VaccinationReviewViewModel: ObservableObject, FlowStepViewModel {
    // Upload state - declare these first
    @Published var isUploading: Bool = false
    @Published var uploadError: String? = nil
    @Published var vaccinations: [Vaccination] = []
    @Published var isManualEntry: Bool = false

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

    var title: String { "Vaccination" }
    var isComplete: Bool { true }
    var isStaticVideo: Bool { true }

    // Custom initializer
    init(scanViewModel: ScanDocumentViewModel = ScanDocumentViewModel()) {
        self.scanViewModel = scanViewModel
        
        // Set up callback for when images or files are added to automatically upload
        self.scanViewModel.onImagesOrFilesAdded = { [weak self] in
            guard let self = self else { return }
            // Only upload if we have images/files and not currently uploading
            if !self.isUploading && 
               (!self.scanViewModel.selectedImages.isEmpty || !self.scanViewModel.selectedFileURLs.isEmpty) {
                self.uploadAndParseVaccinations()
            }
        }
    }

    // Upload and parse vaccinations from API
    func uploadAndParseVaccinations() {
        isUploading = true
        uploadError = nil
        APIService.shared.uploadDocument(endpoint: "post/vaccination", images: selectedImages, fileURLs: selectedFileURLs) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let responseString):
                    print(responseString)
                    // Try to decode [Vaccination] from responseString
                    if let data = responseString.data(using: .utf8),
                       let vaccinationsResponse = try? JSONDecoder().decode(VaccinationResponse.self, from: data) {
                        self?.vaccinations = vaccinationsResponse.data
                        // Auto-show modal flag could be set here if needed
                    } else {
                        self?.uploadError = "Failed to parse vaccinations."
                    }
                case .failure(let error):
                    self?.uploadError = error.localizedDescription
                }
            }
        }
    }

    func handleSave() {
        // Send the current vaccinations with the APIService to the backend
        isUploading = true
        uploadError = nil
        
        // Send the vaccinations array directly to the backend
        APIService.shared.uploadData(self.vaccinations, endpoint: "post/json/vaccinations") { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                
                switch result {
                case .success(let response):
                    print("Successfully saved vaccinations: \(response)")
                    // You could add additional success handling here if needed
                    
                case .failure(let error):
                    self?.uploadError = "Failed to save vaccinations: \(error.localizedDescription)"
                    print("Error saving vaccinations: \(error)")
                }
            }
        }
    }

    // Optionally, allow editing a vaccination in the array
    func updateVaccination(_ vaccination: Vaccination, at index: Int) {
        guard vaccinations.indices.contains(index) else { return }
        vaccinations[index] = vaccination
    }
    
    func addVaccination(_ vaccination: Vaccination) {
        vaccinations.append(vaccination)
    }
    
    func removeVaccinations(at offsets: IndexSet) {
        vaccinations.remove(atOffsets: offsets)
    }

    func onNext(completion: @escaping (Bool) -> Void) {
        handleSave()
        completion(isComplete)
    }
}

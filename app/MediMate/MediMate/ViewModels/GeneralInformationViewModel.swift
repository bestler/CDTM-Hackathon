import Foundation
import SwiftUI

class GeneralInformationViewModel: ObservableObject, FlowStepViewModel {
    // Upload state
    @Published var isUploading: Bool = false
    @Published var uploadError: String? = nil
    @Published var generalInformation: GeneralInformation? = nil
    @Published var isManualEntry: Bool = false
    
    // ScanDocumentViewModel is a child view model
    @Published var scanViewModel: ScanDocumentViewModel
    
    // Computed properties
    var selectedImages: [UIImage] {
        get { scanViewModel.selectedImages }
        set { scanViewModel.selectedImages = newValue }
    }
    
    var selectedFileURLs: [URL] {
        get { scanViewModel.selectedFileURLs }
        set { scanViewModel.selectedFileURLs = newValue }
    }
    
    var title: String { "General Information" }
    var isComplete: Bool { true }
    var isStaticVideo: Bool { true }
    var videoName: String { "greeting_insurance_card" }
    
    // Custom initializer
    init(scanViewModel: ScanDocumentViewModel = ScanDocumentViewModel()) {
        self.scanViewModel = scanViewModel
        
        // Set up callback for when images or files are added to automatically upload
        self.scanViewModel.onImagesOrFilesAdded = { [weak self] in
            guard let self = self else { return }
            // Only upload if we have images/files and not currently uploading
            if !self.isUploading && 
               (!self.scanViewModel.selectedImages.isEmpty || !self.scanViewModel.selectedFileURLs.isEmpty) {
                self.uploadAndParseGeneralInformation()
            }
        }
    }
    
    // Upload and parse general information from API
    func uploadAndParseGeneralInformation() {
        isUploading = true
        uploadError = nil
        APIService.shared.uploadDocument(endpoint: "post/generalInformation", images: selectedImages, fileURLs: selectedFileURLs) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let responseString):
                    print(responseString)
                    // Try to decode GeneralInformation from responseString
                    if let data = responseString.data(using: .utf8),
                       let generalInfoResponse = try? JSONDecoder().decode(GeneralInformationResponse.self, from: data) {
                        self?.generalInformation = generalInfoResponse.data
                    } else {
                        self?.uploadError = "Failed to parse general information."
                    }
                case .failure(let error):
                    self?.uploadError = error.localizedDescription
                }
            }
        }
    }
    
    func handleSave() {
        // Send the current general information with the APIService to the backend
        isUploading = true
        uploadError = nil
        
        if let generalInfo = self.generalInformation {
            APIService.shared.uploadData(generalInfo, endpoint: "post/json/generalInformation") { [weak self] result in
                DispatchQueue.main.async {
                    self?.isUploading = false
                    
                    switch result {
                    case .success(let response):
                        print("Successfully saved general information: \(response)")
                    case .failure(let error):
                        self?.uploadError = "Failed to save general information: \(error.localizedDescription)"
                        print("Error saving general information: \(error)")
                    }
                }
            }
        }
    }
    
    // Update general information
    func updateGeneralInformation(_ generalInfo: GeneralInformation) {
        generalInformation = generalInfo
    }
    
    func onNext(completion: @escaping (Bool) -> Void) {
        handleSave()
        completion(isComplete)
    }
}

// Response structure for the API
struct GeneralInformationResponse: Codable {
    let message: String
    let data: GeneralInformation
}

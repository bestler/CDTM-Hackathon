import Foundation
import SwiftUI

class ScanDocumentViewModel: ObservableObject, FlowStepViewModel {
    @Published var inputType: InputType = .camera
    @Published var selectedImages: [UIImage] = []
    @Published var selectedFileURLs: [URL] = []
    @Published var isUploading: Bool = false
    @Published var uploadError: String? = nil
    var title: String { "Scan Documents" }
    var isComplete: Bool { uploadResult != nil }
    private(set) var uploadResult: Vaccination? = nil
    var onScanCompleted: ((Vaccination) -> Void)?

    func uploadAndContinue() {
        isUploading = true
        uploadError = nil
        APIService.shared.uploadDocument(images: selectedImages, fileURLs: selectedFileURLs) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let responseString):
                    // TODO: Parse responseString to Vaccination struct
                    // For now, create dummy data
                    let vaccination = Vaccination.example
                    self?.uploadResult = vaccination
                    self?.onScanCompleted?(vaccination)
                case .failure(let error):
                    self?.uploadError = error.localizedDescription
                }
            }
        }
    }

    func onNext(completion: @escaping (Bool) -> Void) {
        completion(uploadResult != nil)
    }
}

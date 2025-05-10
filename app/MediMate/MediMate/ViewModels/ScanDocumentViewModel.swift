
import Foundation
import SwiftUI
// Make sure InputType is available project-wide

class ScanDocumentViewModel: ObservableObject, FlowStepViewModel {
    @Published var inputType: InputType = .camera
    @Published var selectedImages: [UIImage] = [] {
        didSet {
            if !selectedImages.isEmpty {
                onImagesOrFilesAdded?()
            }
        }
    }
    @Published var selectedFileURLs: [URL] = [] {
        didSet {
            if !selectedFileURLs.isEmpty {
                onImagesOrFilesAdded?()
            }
        }
    }
    var title: String { "Scan Documents" }
    var isComplete: Bool { !(selectedImages.isEmpty && selectedFileURLs.isEmpty) }
    
    // Callback for when images or files are added
    var onImagesOrFilesAdded: (() -> Void)?

    func onNext(completion: @escaping (Bool) -> Void) {
        completion(isComplete)
    }
}

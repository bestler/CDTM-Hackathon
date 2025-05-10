
import Foundation
import SwiftUI
// Make sure InputType is available project-wide

class ScanDocumentViewModel: ObservableObject, FlowStepViewModel {
    @Published var inputType: InputType = .camera
    @Published var selectedImages: [UIImage] = []
    @Published var selectedFileURLs: [URL] = []
    var title: String { "Scan Documents" }
    var isComplete: Bool { !(selectedImages.isEmpty && selectedFileURLs.isEmpty) }

    func onNext(completion: @escaping (Bool) -> Void) {
        completion(isComplete)
    }
}

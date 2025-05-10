import Foundation

enum InputType: String, CaseIterable, Identifiable {
    case camera, photoLibrary, files
    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .camera: return "Scan with Camera"
        case .photoLibrary: return "Photo Library"
        case .files: return "Files"
        }
    }
}

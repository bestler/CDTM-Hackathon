//
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

import SwiftUI
import HealthKit
import PDFKit
import UIKit
import PhotosUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isAuthorized = false
    @Published var allData: [String: String] = [:]
    let healthKitManager = HealthKitManager()

    func requestHealthKit() {
        healthKitManager.requestAuthorization { [weak self] success in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.fetchAllData()
                }
            }
        }
    }

    func fetchAllData() {
        healthKitManager.fetchAllData()
        self.allData = healthKitManager.allData
    }
}



struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var cameraManager = CameraManager()
    @State private var isUploading = false
    @State private var uploadResult: String? = nil
    @State private var inputType: InputType = .camera

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // HealthKit Section
                    Section(header: Text("Apple HealthKit Integration").font(.headline)) {
                        if viewModel.isAuthorized {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Health Data Overview:").bold()
                                if viewModel.healthKitManager.allData.isEmpty {
                                    Text("No data available.")
                                } else {
                                    ForEach(Array(viewModel.healthKitManager.allData.keys.sorted()), id: \.self) { key in
                                        HStack {
                                            Text(key).fontWeight(.semibold)
                                            Spacer()
                                            Text(viewModel.healthKitManager.allData[key] ?? "-")
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                                Button("Refresh Data") {
                                    viewModel.fetchAllData()
                                }
                            }
                        } else {
                            Button("Connect to Apple HealthKit") {
                                viewModel.requestHealthKit()
                            }
                        }
                    }

                    // Document Section
                    Section(header: Text("Scan or Upload Medical Document").font(.headline)) {
                        VStack(spacing: 12) {
                            Picker("Select Input Type", selection: $inputType) {
                                ForEach(InputType.allCases) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())

                            if (inputType == .camera || inputType == .photoLibrary), let image = cameraManager.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(8)
                                if isUploading {
                                    ProgressView("Uploading...")
                                } else {
                                    Button("Send Image to API") {
                                        isUploading = true
                                        uploadResult = nil
                                        APIService.shared.uploadImage(image) { result in
                                            DispatchQueue.main.async {
                                                isUploading = false
                                                switch result {
                                                case .success(let msg):
                                                    uploadResult = "Upload successful: \(msg)"
                                                case .failure(let error):
                                                    uploadResult = "Upload failed: \(error.localizedDescription)"
                                                }
                                            }
                                        }
                                    }
                                }
                                if let uploadResult = uploadResult {
                                    Text(uploadResult)
                                        .font(.caption)
                                        .foregroundColor(uploadResult.contains("successful") ? .green : .red)
                                }
                            } else if inputType == .files, let fileURL = cameraManager.selectedFileURL {
                                PDFPreview(url: fileURL)
                                    .frame(height: 200)
                                    .cornerRadius(8)
                                Text("Selected file: \(fileURL.lastPathComponent)")
                                if isUploading {
                                    ProgressView("Uploading...")
                                } else {
                                    Button("Send PDF to API") {
                                        isUploading = true
                                        uploadResult = nil
                                        APIService.shared.uploadPDF(url: fileURL) { result in
                                            DispatchQueue.main.async {
                                                isUploading = false
                                                switch result {
                                                case .success(let msg):
                                                    uploadResult = "Upload successful: \(msg)"
                                                case .failure(let error):
                                                    uploadResult = "Upload failed: \(error.localizedDescription)"
                                                }
                                            }
                                        }
                                    }
                                }
                                if let uploadResult = uploadResult {
                                    Text(uploadResult)
                                        .font(.caption)
                                        .foregroundColor(uploadResult.contains("successful") ? .green : .red)
                                }
                            }

                            HStack(spacing: 16) {
                                Button(action: {
                                    switch inputType {
                                    case .camera:
                                        cameraManager.isShowingImagePicker = true
                                    case .photoLibrary:
                                        cameraManager.isShowingPhotoPicker = true
                                    case .files:
                                        cameraManager.isShowingDocumentPicker = true
                                    }
                                }) {
                                    Label("Select Document", systemImage: "plus")
                                }
                                Button(action: {
                                    cameraManager.selectedImage = nil
                                    cameraManager.selectedFileURL = nil
                                    uploadResult = nil
                                }) {
                                    Label("Clear Selection", systemImage: "trash")
                                }
                                .disabled(cameraManager.selectedImage == nil && cameraManager.selectedFileURL == nil)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("MediMate")
        }
        .fullScreenCover(isPresented: $cameraManager.isShowingImagePicker) {
            ZStack {
                Color.black.ignoresSafeArea()
                ImagePicker(image: $cameraManager.selectedImage)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .sheet(isPresented: $cameraManager.isShowingPhotoPicker) {
            PhotoLibraryPicker(image: $cameraManager.selectedImage)
        }
        .sheet(isPresented: $cameraManager.isShowingDocumentPicker) {
            DocumentPicker(fileURL: $cameraManager.selectedFileURL)
        }
    }
}

struct PDFPreview: View {
    let url: URL
    var body: some View {
        if let pdfDocument = PDFDocument(url: url) {
            PDFKitView(document: pdfDocument)
        } else {
            Text("Cannot preview PDF.")
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .clear
        return pdfView
    }
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

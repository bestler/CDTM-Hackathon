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

// Import the AppleHealth models
//import HealthModels

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

    // Post Apple Health data to server
    func postAppleHealthData(completion: @escaping (Result<String, Error>) -> Void) {
        print("Uploading data to server...")
        let appleHealth = healthKitManager.toAppleHealth()
        print(appleHealth)
        APIService.shared.uploadHealthData(appleHealth, completion: completion)
    }
}



struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var cameraManager = CameraManager()
    @State private var isUploading = false
    @State private var uploadResult: String? = nil
    @State private var inputType: InputType = .camera

    @State private var healthUploadResult: String? = nil
    @State private var isUploadingHealth = false

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
                                Divider()
                                if isUploadingHealth {
                                    ProgressView("Uploading Health Data...")
                                } else {
                                    Button("Send Health Data to API") {
                                        isUploadingHealth = true
                                        healthUploadResult = nil
                                        viewModel.postAppleHealthData { result in
                                            DispatchQueue.main.async {
                                                isUploadingHealth = false
                                                switch result {
                                                case .success(let msg):
                                                    healthUploadResult = "Upload successful: \(msg)"
                                                case .failure(let error):
                                                    healthUploadResult = "Upload failed: \(error.localizedDescription)"
                                                }
                                            }
                                        }
                                    }
                                }
                                if let healthUploadResult = healthUploadResult {
                                    Text(healthUploadResult)
                                        .font(.caption)
                                        .foregroundColor(healthUploadResult.contains("successful") ? .green : .red)
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

                            // Preview for image or PDF
                            if (inputType == .camera || inputType == .photoLibrary), !cameraManager.selectedImages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(cameraManager.selectedImages.enumerated()), id: \ .offset) { idx, image in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(8)
                                                Button(action: {
                                                    cameraManager.selectedImages.remove(at: idx)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                        .background(Color.white.opacity(0.7))
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: 6, y: -6)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 130)
                            } else if inputType == .files, !cameraManager.selectedFileURLs.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(cameraManager.selectedFileURLs.enumerated()), id: \ .offset) { idx, fileURL in
                                            ZStack(alignment: .topTrailing) {
                                                PDFPreview(url: fileURL)
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(8)
                                                Button(action: {
                                                    cameraManager.selectedFileURLs.remove(at: idx)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                        .background(Color.white.opacity(0.7))
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: 6, y: -6)
                                                VStack {
                                                    Spacer()
                                                    Text(fileURL.lastPathComponent)
                                                        .font(.caption2)
                                                        .lineLimit(1)
                                                        .frame(maxWidth: 100)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(height: 130)
                            }

                            // Unified upload button
                            if (!cameraManager.selectedImages.isEmpty || !cameraManager.selectedFileURLs.isEmpty) {
                                if isUploading {
                                    ProgressView("Uploading...")
                                } else {
                                    Button("Send to API") {
                                        isUploading = true
                                        uploadResult = nil
                                        if !cameraManager.selectedImages.isEmpty {
                                            APIService.shared.uploadImages(cameraManager.selectedImages) { result in
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
                                        } else if !cameraManager.selectedFileURLs.isEmpty {
                                            APIService.shared.uploadPDFs(urls: cameraManager.selectedFileURLs) { result in
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
                                    cameraManager.selectedImages = []
                                    cameraManager.selectedFileURLs = []
                                    uploadResult = nil
                                }) {
                                    Label("Clear Selection", systemImage: "trash")
                                }
                                .disabled(cameraManager.selectedImages.isEmpty && cameraManager.selectedFileURLs.isEmpty)
                            }
                        }
// MARK: - Unified Document Upload API
                    }
                }
                .padding()
            }
            .navigationTitle("MediMate")
        }
        .fullScreenCover(isPresented: $cameraManager.isShowingImagePicker) {
            ZStack {
                Color.black.ignoresSafeArea()
                ImagePicker(images: $cameraManager.selectedImages)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .sheet(isPresented: $cameraManager.isShowingPhotoPicker) {
            PhotoLibraryPicker(images: $cameraManager.selectedImages)
        }
        .sheet(isPresented: $cameraManager.isShowingDocumentPicker) {
            DocumentPicker(fileURLs: $cameraManager.selectedFileURLs)
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

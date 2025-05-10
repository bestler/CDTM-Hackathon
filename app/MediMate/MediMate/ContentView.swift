//
//  ContentView.swift
//  MediMate
//
//  Created by Simon Bestler on 09.05.25.
//

import SwiftUI
import SwiftData
import HealthKit

import UIKit
import PhotosUI

// Add HealthKitManager as an observable object
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
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var viewModel = ContentViewModel()

    @StateObject private var cameraManager = CameraManager()
    @State private var isUploading = false
    @State private var uploadResult: String? = nil

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Section(header: Text("Apple HealthKit Integration")) {
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

            Section(header: Text("Scan Medical Document")) {
                VStack(spacing: 12) {
                    if let image = cameraManager.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                        if isUploading {
                            ProgressView("Uploading...")
                        } else {
                            Button("Send to API") {
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
                    }
                    Button(action: {
                        cameraManager.isShowingImagePicker = true
                    }) {
                        Label("Scan Document", systemImage: "camera")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .fullScreenCover(isPresented: $cameraManager.isShowingImagePicker) {
            ZStack {
                Color.black.ignoresSafeArea()
                ImagePicker(image: $cameraManager.selectedImage)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

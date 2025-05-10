// APIService.swift
// Handles uploading images to the API

import Foundation
import UIKit
import HealthKit
//import HealthModels

class APIService {

    /// Unified document upload for image or PDF. If both are provided, image is preferred.
    func uploadDocument(image: UIImage?, fileURL: URL?, completion: @escaping (Result<String, Error>) -> Void) {
        if let image = image {
            self.uploadImages([image], completion: completion)
        } else if let fileURL = fileURL {
            self.uploadPDF(url: fileURL, completion: completion)
        } else {
            completion(.failure(NSError(domain: "No file selected", code: 0)))
        }
    }
    static let shared = APIService()
    private init() {}

    // Upload Apple Health data as JSON
    func uploadHealthData(_ healthData: AppleHealth, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://172.20.10.4:8000/post/appleHealth") else {
            print("[APIService] Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(healthData)
            request.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("[APIService] JSON Body: \(jsonString)")
            }
        } catch {
            print("[APIService] JSON encoding error: \(error)")
            completion(.failure(error))
            return
        }

        print("[APIService] Sending request to: \(url)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[APIService] Network error: \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[APIService] Response status code: \(httpResponse.statusCode)")
            } else {
                print("[APIService] No HTTPURLResponse received")
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("[APIService] Response body: \(responseString)")
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server error", code: 0)))
                return
            }
            completion(.success("Success"))
        }
        task.resume()
    }


    func uploadImages(_ images: [UIImage], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://172.20.10.4:8000/post/vaccinations") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        for (idx, image) in images.enumerated() {
            let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"scan\(idx+1).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success("Success"))
        }
        task.resume()
    }

    func uploadPDF(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiURL = URL(string: "https://your-api-endpoint.com/upload") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let pdfData = try? Data(contentsOf: url) else {
            completion(.failure(NSError(domain: "PDF Read Error", code: 0)))
            return
        }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"document.pdf\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
        body.append(pdfData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success("Success"))
        }
        task.resume()
    }
}

// APIService.swift
// Handles uploading images to the API

import Foundation
import UIKit
import HealthKit
//import HealthModels

class APIService {

    let baseURL = "https://fastapi-service-1056955526781.europe-west3.run.app/"

    /// Unified document upload for images and PDFs. If both are provided, uploads both.
    func uploadDocument(endpoint: String, images: [UIImage], fileURLs: [URL], completion: @escaping (Result<String, Error>) -> Void) {
        if !images.isEmpty {
            self.uploadImages(images, endpoint: endpoint) { result in
                if !fileURLs.isEmpty {
                    // If both images and PDFs, upload PDFs after images
                    self.uploadPDFs(urls: fileURLs, endpoint: endpoint, completion: completion)
                } else {
                    completion(result)
                }
            }
        } else if !fileURLs.isEmpty {
            self.uploadPDFs(urls: fileURLs, endpoint: endpoint, completion: completion)
        } else {
            completion(.failure(NSError(domain: "No file selected", code: 0)))
        }
    }
    static let shared = APIService()
    private init() {}

    // Upload Apple Health data as JSON
    func uploadHealthData(_ healthData: AppleHealth, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL + "post/appleHealth") else {
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
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server error", code: 0)))
                return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("[APIService] Response body: \(responseString)")
                completion(.success(responseString))
            } else {
                completion(.success(""))
            }
        }
        task.resume()
    }


    func uploadImages(_ images: [UIImage], endpoint: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
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
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.success(""))
            }
        }
        task.resume()
    }

    func uploadPDFs(urls: [URL], endpoint: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiURL = URL(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        for (idx, url) in urls.enumerated() {
            guard let pdfData = try? Data(contentsOf: url) else { continue }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"document\(idx+1).pdf\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
            body.append(pdfData)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.success(""))
            }
        }
        task.resume()
    }

    /// Generic function to upload any Codable data to the specified endpoint
    /// - Parameters:
    ///   - data: Any data type conforming to Codable
    ///   - endpoint: API endpoint to send the data to (will be appended to baseURL)
    ///   - completion: Completion handler that returns a Result with either a response string or an Error
    func uploadData<T: Codable>(_ data: T, endpoint: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            print("[APIService] Invalid URL for endpoint: \(endpoint)")
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("[APIService] JSON Body for \(endpoint): \(jsonString)")
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
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(NSError(domain: "Server error", code: statusCode)))
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("[APIService] Response body: \(responseString)")
                completion(.success(responseString))
            } else {
                completion(.success(""))
            }
        }
        task.resume()
    }

    
}

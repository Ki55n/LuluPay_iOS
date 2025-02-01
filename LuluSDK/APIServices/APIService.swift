//
//  APIService.swift
//  LuluSDK
//
//  Created by boyapati kumar on 01/02/25.
//

import Foundation

class APIService {
    static let shared = APIService()  // Singleton instance
    
    private init() {}  // Private initializer to enforce singleton pattern
    
    func request(url: String,
                 method: HTTPMethod,
                 parameters: [String: String]? = nil,
                 headers: [String: String]? = nil,
                 completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Set headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Encode parameters for x-www-form-urlencoded
        if let parameters = parameters, method != .get {
            let parameterArray = parameters.map { "\($0.key)=\($0.value)" }
            let parameterString = parameterArray.joined(separator: "&")
            request.httpBody = parameterString.data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
}

// Enum for HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// API Error Enum
enum APIError: Error {
    case invalidURL
    case invalidParameters
    case noData
    case decodingFailed
}

// API Response Wrapper
struct APIResponse<T: Decodable> {
    let data: T?
    let error: Error?
}


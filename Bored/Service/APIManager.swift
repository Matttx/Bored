//
//  APIManager.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import Foundation

let BASE_URL = "https://www.boredapi.com/api"

protocol APIManagerProtocol {
    func task<T: Codable>(url: String, method: APIManager.HTTPMethod, queries: [String: String]) async throws -> T?
}

class APIManager: APIManagerProtocol {
    
    static var shared = APIManager()
    
    enum HTTPMethod: String {
        case GET, POST
    }
    
    private func handleAPIError(urlResponse: URLResponse?) throws {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw APIError.serverError
        }
        
        switch response.statusCode {
        case 400:
            throw APIError.badRequest
        case 404:
            throw APIError.notFound
        default:
            break
        }
    }
    
    func task<T: Codable>(url: String, method: HTTPMethod = .GET, queries: [String: String] = [:]) async throws -> T {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            throw APIError.network
        }
        
        guard var components = URLComponents(string: "\(BASE_URL)\(url)") else {
            throw APIError.invalidURL
        }
        
        if !queries.isEmpty {
            components.queryItems = queries.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.timeoutInterval = 5
        
        var data: Data
        var response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            print("Error: \(error)")
            throw APIError.unknown(error)
        }
        
        try handleAPIError(urlResponse: response)

        var decodedData: T
        
        do {
            decodedData = try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error: \(error)")
            throw APIError.invalidData
        }
        
        return decodedData
    }
}


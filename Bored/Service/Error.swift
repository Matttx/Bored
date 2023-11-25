//
//  Error.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidURL
    
    case badRequest
    
    case serverError
    
    case notFound
    
    case invalidData
    
    case network
    
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was invalid. Please try again later."
        case .badRequest:
            return "The sending request failed. Please try again later."
        case .serverError:
            return "There was an error with the server. Please try again later."
        case .notFound:
            return "The given URL was not found. Please try again later."
        case .invalidData:
            return "The data is invalid. Please try again later."
        case .network:
            return "The internet connection appears to be offline."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

//
//  Activity.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import Foundation

struct Activity: Codable {
    var label: String?
    var accessibility: Double?
    var type: String?
    var participants: Int?
    var price: Double?
    var link: String?
    var key: String?
    
    var priceRange: String {
        if let price = price {
            return switch price {
            case 0:
                "Free"
            case 0.1...0.3:
                "€"
            case 0.4...0.7:
                "€€"
            case 0.8...1:
                "€€€"
            default:
                "???"
            }
        } else {
            return "Unkwnown"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case label = "activity"
        case accessibility
        case type
        case participants
        case price
        case link
        case key
    }
    
    static func fetchRandom() async throws -> Activity {
        do {
            let data: Activity = try await APIManager.shared.task(url: "/activity/")
            
            return data
        } catch {
            print("Error fetchRandom: \(error)")
            throw error
        }
    }
}

// MARK: - Store

@MainActor
class ActivityStore: ObservableObject {
    @Published var activity: Activity = .init()
    
    enum Phase {
        case firstLoading, loading, success, failure
    }
    
    @Published var phase: Phase = .firstLoading
    @Published var error: Error?
    
    func fetchRandom() async {
        do {
            phase = .loading
            activity = try await Activity.fetchRandom()
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}

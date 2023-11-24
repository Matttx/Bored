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
            case 0.01...0.3:
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
    
    static func fetchActivity(type: String, participants: String) async throws -> Activity {
        
        var queries: [String: String] = [:]
        
        if type != "All" {
            queries["type"] = type.lowercased()
        }
        
        if participants != "Whatever" {
            queries["participants"] = participants
        }
        
        do {
            let data: Activity = try await APIManager.shared.task(url: "/activity", queries: queries)
            
            return data
        } catch {
            print("Error fetchActivity: \(error)")
            throw error
        }
    }
}

// MARK: - Store

@MainActor
class ActivityStore: ObservableObject {
    @Published var activity: Activity = .init()
    
    @Published var selectedType: String = "All"
    
    @Published var selectedParticipants: String = "Whatever"
    
    enum Phase {
        case firstLoading, loading, success, failure
    }
    
    @Published var phase: Phase = .firstLoading
    @Published var error: Error?
        
    func fetchActivity() {
        guard phase != .loading else {
            return
        }
        
        Task {
            do {
                phase = .loading
                activity = try await Activity.fetchActivity(type: selectedType, participants: selectedParticipants)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.phase = .success
                }
            } catch {
                phase = .failure
                self.error = error
            }
        }
    }
}

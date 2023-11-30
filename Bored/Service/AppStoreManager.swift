//
//  AppStoreManager.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 30/11/2023.
//

import Foundation
import StoreKit
import SwiftUI

class AppStoreManager: ObservableObject {
    
    @AppStorage("MaxActivityIdxUntilAppReview") var maxActivityIdxUntilAppReview = 15
    
    @AppStorage("ActivityCounter") var activityCounter = 0
    
    func handleAppReview() {
        if activityCounter >= maxActivityIdxUntilAppReview {
            showAppReview()
            maxActivityIdxUntilAppReview += 15
        }
    }
    
    private func showAppReview() {
        guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
              return
        }
        
        SKStoreReviewController.requestReview(in: currentScene)
    }
}

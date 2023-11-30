//
//  BoredApp.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import SwiftUI
import TipKit

@main
struct BoredApp: App {
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .task {
                    try? Tips.configure()
                }
        }
    }
}

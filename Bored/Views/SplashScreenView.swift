//
//  SplashScreenView.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 25/11/2023.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var isActive = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                splashScreen
            }
        }
        .animation(.easeIn, value: isActive)
    }
    
    private var splashScreen: some View {
        VStack {
            Text("Bored")
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .light ? .white : .black)
        .keyframeAnimator(initialValue: SplashScreenAnimation()) { content, value in
            content
                .scaleEffect(value.scale)
                .opacity(value.opacity)
        } keyframes: { value in
            KeyframeTrack(\.scale) {
                LinearKeyframe(1.0, duration: 0.40)
                SpringKeyframe(2.0, duration: 1.0, spring: .bouncy(duration: 1.0, extraBounce: 0.3))
            }
            
            KeyframeTrack(\.opacity) {
                LinearKeyframe(1.0, duration: 1.40)
                LinearKeyframe(0.0, duration: 0.5)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                isActive = true
            }
        }
    }
    
    private struct SplashScreenAnimation {
        var scale = 1.0
        var opacity = 1.0
    }
    
    private struct ContentScreenAnimation {
        var opacity = 0.0
    }
}

#Preview {
    SplashScreen()
}

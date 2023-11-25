//
//  ContentView.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var store = ActivityStore()
    
    let screenSize = UIScreen.main.bounds
    
    @State private var isPresentedSafariView = false
    
    @State private var isPresentedFilters = false
    
    @State private var isPresentedSettings = false
    
    var isFiltered: Bool {
        store.selectedType != "All" || store.selectedParticipants != "Whatever"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                content
            }
        }
        .onAppear {
            store.fetchActivity()
        }
        .sheet(isPresented: $isPresentedSafariView) {
            if let link = store.activity.link,
               let url = URL(string: link) {
                SafariView(url: url)
            }
        }
        .sheet(isPresented: $isPresentedFilters) {
            FiltersSheet()
                .presentationDetents([.fraction(0.4)])
                .environmentObject(store)
        }
        .sheet(isPresented: $isPresentedSettings) {
            SettingsView()
                .presentationDetents([.fraction(0.9)])
        }
        .animation(.smooth(extraBounce: 0.6), value: store.phase)
    }
    
    private var failureContent: some View {
        VStack {
            if let error = store.error {
                Text(error.localizedDescription)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var content: some View {
        VStack {
            Text("Bored")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: screenSize.width - 32)
                .overlay(alignment: .leading) {
                    Button {
                        isPresentedSettings = true
                    } label: {
                        Image(systemName: "gearshape.circle")
                            .symbolEffect(.bounce, value: isPresentedSettings)
                            .font(.system(size: 20))
                    }
                }
                .overlay(alignment: .trailing) {
                    Button {
                        isPresentedFilters = true
                    } label: {
                        Image(systemName: isFiltered ? "list.bullet.circle.fill" : "list.bullet.circle")
                            .contentTransition(.symbolEffect(.replace.downUp.wholeSymbol))
                            .keyframeAnimator(
                                initialValue: FiltersAnimationValues(),
                                trigger: isFiltered) { content, value in
                                    content
                                        .scaleEffect(value.scale)
                                } keyframes: { value in
                                    KeyframeTrack(\.scale) {
                                        LinearKeyframe(1.0, duration: 0.2)
                                        SpringKeyframe(1.3, duration: 0.3, spring: .bouncy)
                                        SpringKeyframe(1.0, duration: 0.2, spring: .bouncy)
                                        SpringKeyframe(1.3, duration: 0.3, spring: .bouncy)
                                        SpringKeyframe(1.0, duration: 0.2, spring: .bouncy)
                                    }
                                }
                            .font(.system(size: 20))
                    }
                }
            
            Spacer()
            
            if store.phase == .failure {
                failureContent
            } else {
                successContent
            }
            
            Spacer()
            
            Button {
                store.fetchActivity()
            } label: {
                Text("Another activity")
                    .font(.headline)
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    private var successContent: some View {
        VStack {
            if store.activity.label == nil && store.phase == .success {
                Text("No activity found with theses filters")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .transition(
                        .scale(scale: 0.87)
                        .combined(with: .opacity.animation(.easeInOut(duration: 0.5)))
                    )
            } else if store.phase == .success {
                RoundedRectangle(cornerRadius: 32)
                    .frame(width: screenSize.width / 1.2, height: screenSize.height / 2)
                    .foregroundStyle(.background)
                    .shadow(color: .gray.opacity(0.3), radius: 10)
                    .overlay {
                        cardContent
                    }
                    .transition(
                        .scale(scale: 0.87)
                        .combined(with: .opacity.animation(.easeInOut))
                    )
            } else {
                EmptyView()
            }
        }
        .padding()
    }
    
    private var cardContent: some View {
        VStack {
            Text(store.activity.label ?? "")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            if let link = store.activity.link, !link.isEmpty {
                Button {
                    isPresentedSafariView = true
                } label: {
                    Text("Know more")
                        .font(.footnote)
                        .foregroundStyle(.background)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .overlay(alignment: .bottom) {
            HStack(spacing: 16) {
                detailsItem(systemName: "person.2", value: " \(store.activity.participants ?? 0)")
                detailsItem(systemName: "creditcard", value:  store.activity.priceRange)
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .topTrailing) {
            Text(store.activity.type?.capitalized ?? "")
                .padding(.top, 8)
        }
        .padding()
    }
    
    @ViewBuilder
    private func detailsItem(systemName: String, value: String?) -> some View {
        if let value = value {
            HStack(spacing: 0) {
                Image(systemName: systemName)
                Text(": \(value)")
            }
            .font(.callout)
        }
    }
    
    private struct FiltersAnimationValues {
        var scale = 1.0
    }
}

#Preview {
    ContentView()
}

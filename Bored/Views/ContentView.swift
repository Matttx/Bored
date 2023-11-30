//
//  ContentView.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import SwiftUI
import StoreKit
import TipKit

struct ContentView: View {
    
    private let filterIconTip = FilterIconTip()
    
    private var appStoreManager = AppStoreManager()
    
    @StateObject private var store = ActivityStore()
    
    let screenSize = UIScreen.main.bounds
    
    @State private var isPresentedSafariView = false
    
    @State private var isPresentedFilters = false
    
    @State private var isPresentedSettings = false
    
    var isFiltered: Bool {
        store.selectedType != "All" || store.selectedParticipants != "Whatever"
    }
    
    @State private var counter: Double = 0.0
    @State private var timer: Timer?
    
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
                .presentationDetents([.fraction(0.45)])
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $isPresentedSettings) {
            AboutView()
        }
        .animation(.smooth(extraBounce: 0.6), value: store.phase)
        .onChange(of: store.phase) {
            if store.phase == .loading {
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    self.counter += 0.01
                    
                    if self.counter == 5 {
                        self.timer?.invalidate()
                    }
                    
                    if store.phase == .success {
                        self.timer?.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            counter = 0
                        }
                    }
                }
            }
        }
        .onChange(of: appStoreManager.activityCounter) {
            appStoreManager.handleAppReview()
        }
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
            VStack(spacing: 12) {
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
                            filterIconTip.invalidate(reason: .actionPerformed)
                            isPresentedFilters = true
                         } label: {
                            Image(systemName: "list.bullet.circle")
                                .symbolVariant(isFiltered ? .fill : .none)
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
                        .popoverTip(filterIconTip)
                    }
                
                // UI Loader
                Rectangle()
                    .frame(height: 4)
                    .foregroundStyle(.accent)
                    .phaseAnimator([true, false]) { content, value in
                        content
                            .opacity(value ? 1 : 0.2)
                    }
                    .opacity(counter > 1.5 && store.phase == .loading ? 1 : 0)
                    .animation(.easeInOut, value: counter)
            }
            
            Spacer()
            
            if store.phase == .failure {
                failureContent
            } else {
                successContent
            }
            
            Spacer()
            
            Button {
                if FilterIconTip.fetchActivityAtleast3TimesEvent.donations.count > 3 {
                    filterIconTip.invalidate(reason: .actionPerformed)
                }
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
                    .onTapGesture {
                        if FilterIconTip.fetchActivityAtleast3TimesEvent.donations.count > 3 {
                            filterIconTip.invalidate(reason: .actionPerformed)
                        }
                        store.fetchActivity()
                    }
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
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}

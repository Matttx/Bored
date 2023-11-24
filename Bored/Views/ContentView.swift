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
    
    var isFiltered: Bool {
        store.selectedType != "All" || store.selectedParticipants != "Whatever"
    }
        
    var body: some View {
        NavigationStack {
            VStack {
                content
            }
        }
        .task {
            await store.fetchActivity()
        }
        .sheet(isPresented: $isPresentedSafariView) {
            if let link = store.activity.link,
               let url = URL(string: link) {
                SafariView(url: url)
            }
        }
        .sheet(isPresented: $isPresentedFilters) {
            FiltersSheet()
                .presentationDetents([.fraction(0.5)])
                .environmentObject(store)
        }
        .animation(.easeInOut(duration: 2), value: store.activity.label)
        .padding()
    }
    
    @ViewBuilder
    private var content: some View {
        switch store.phase {
        case .firstLoading:
            EmptyView()
        case .failure:
            failureContent
        default:
            successContent
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
    
    private var successContent: some View {
        VStack {
            Text("Bored")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: screenSize.width / 1.2)
                .overlay(alignment: .trailing) {
                    Button {
                        isPresentedFilters = true
                    } label: {
                        Image(systemName: isFiltered ? "list.bullet.circle.fill" : "list.bullet.circle")
                            .font(.system(size: 20))
                    }
                }
            
            Spacer()
            
            if store.activity.label == nil && store.phase == .success {
                Text("No activity found with theses filters")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
            } else if store.phase == .success {
                RoundedRectangle(cornerRadius: 32)
                    .frame(width: screenSize.width / 1.2, height: screenSize.height / 2)
                    .foregroundStyle(.background)
                    .shadow(color: .gray, radius: 10)
                    .overlay {
                        cardContent
                    }
            } else {
                EmptyView()
            }
            
            Spacer()
            
            Button {
                Task {
                    await store.fetchActivity()
                }
            } label: {
                Text("Another activity")
                    .font(.headline)
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
        }
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
}

#Preview {
    ContentView()
}
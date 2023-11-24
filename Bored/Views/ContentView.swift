//
//  ContentView.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var store = ActivityStore()
    
    var body: some View {
        VStack {
            content
        }
        .task {
            await store.fetchRandom()
        }
        .padding()
    }
    
    @ViewBuilder
    private var content: some View {
        switch store.phase {
        case .loading:
            ProgressView()
        case .success:
            successContent
        case .failure:
            failureContent
        case .none:
            EmptyView()
        }
    }
    
    private var failureContent: some View {
        VStack {
            if let error = store.error {
                Text(error.localizedDescription)
                    .font(.title)
                    .bold()
            }
        }
    }
    
    private var successContent: some View {
        VStack {
            Text(store.activity.label ?? "")
                .font(.largeTitle)
        }
    }
}

#Preview {
    ContentView()
}

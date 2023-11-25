//
//  AboutView.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 25/11/2023.
//

import SwiftUI

struct AboutView: View {
    
    @AppStorage("colorSchemeValue") private var colorSchemeValue: String = "system"
        
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            content
                .padding()
        }
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            Text("About")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 20))
                    }
                }
            VStack(spacing: 16) {
                Button {
                    Text("Test")
                } label: {
                    Text("Contribute to the API")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                
                Button {
                    if let url = URL(string: "https://github.com/drewthoennes") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } label: {
                    Text("Github: @drewthoennes")
                        .font(.headline)
                        .foregroundStyle(.background)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .buttonStyle(.borderedProminent)
                
                Text("Application made with 🤍 by Matteo Fauchon, using the Bored API by @drewthoennes to give you the different activities")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AboutView()
}

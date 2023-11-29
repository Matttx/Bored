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
    
    @State private var isPresentedContribution = false
    
    var body: some View {
        NavigationStack {
            content
        }
        .sheet(isPresented: $isPresentedContribution) {
            if let url = URL(string: "https://www.boredapi.com/contributing") {
                SafariView(url: url)
            }
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
                .padding(.horizontal)
            
            VStack {
                Button {
                    isPresentedContribution = true
                } label: {
                    Text("Contribute to the API")
                        .font(.headline)
                        .foregroundStyle(.background)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .buttonStyle(.borderedProminent)
                
                Text("Give one of your ideas to avoid **bored**om!")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 16) {
                
                githubButton(label: "drewthoennes")
                githubButton(label: "Matttx")    
                
                Text("Application made with 🤍 by Matteo Fauchon, using the Bored API by @drewthoennes to give you the different activities")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)

        }
        .frame(maxWidth: .infinity)
    }
    
    private func githubButton(label: String) -> some View {
        Button {
            if let url = URL(string: "https://github.com/\(label)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } label: {
            HStack {
                Text("@\(label)")
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(.github)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.horizontal, 16)
                    }
            }
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: 40)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    AboutView()
}

//
//  FiltersSheet.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 24/11/2023.
//

import SwiftUI

struct FiltersSheet: View {
    
    @EnvironmentObject private var store: ActivityStore
    
    @Environment(\.dismiss) private var dismiss
    
    private let types = [
        "All",
        "Education",
        "Recreational",
        "Social",
        "DIY",
        "Charity",
        "Cooking",
        "Relaxation",
        "Music",
        "Busywork"
    ]
    
    private let participants = [
        "Whatever",
        "1",
        "2",
        "3",
        "4"
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Filters")
                .font(.title2)
                .fontWeight(.semibold)
            HStack {
                Text("Activity type")
                Spacer()
                Picker("", selection: $store.selectedType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.background)
                        .shadow(color: .gray, radius: 5)
                )
            }
            
            Divider()
                .background(.accent)
                .padding(.horizontal)
            
            HStack {
                Text("Participants")
                Spacer()
                Picker("", selection: $store.selectedParticipants) {
                    ForEach(participants, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.automatic)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.background)
                        .shadow(color: .gray, radius: 5)
                )
            }
            
            Spacer(minLength: 0)
            
            Button {
                dismiss()
                Task {
                    await store.fetchActivity()
                }
            } label: {
                Text("Confirm")
                    .font(.headline)
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    FiltersSheet()
        .environmentObject(ActivityStore())
}

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
    
    @State private var selectedType: String = "All"
    
    @State private var selectedParticipants: String = "Whatever"
    
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
        VStack(spacing: 24) {
            Text("Filters")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        selectedType = "All"
                        selectedParticipants = "Whatever"
                    } label: {
                        Text("Clear")
                            .font(.headline)
                    }
                }
            
            VStack(spacing: 16) {
                HStack {
                    Text("Activity type")
                        .font(.headline)
                Spacer()
                    Picker("", selection: $selectedType) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.background)
                            .shadow(color: .gray, radius: 1)
                    )
                }
                
                Divider()
                    .background(.accent)
                    .padding(.horizontal)
                
                HStack {
                    Text("Participants")
                        .font(.headline)
                    Spacer()
                    Picker("", selection: $selectedParticipants) {
                        ForEach(participants, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.background)
                            .shadow(color: .gray, radius: 1)
                    )
                }
            }
            
            Spacer(minLength: 0)
            
            Button {
                dismiss()
                store.fetchActivity(type: selectedType, participants: selectedParticipants)
            } label: {
                Text("Confirm")
                    .font(.headline)
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            selectedType = store.selectedType
            selectedParticipants = store.selectedParticipants
        }
        .padding()
    }
}

#Preview {
    FiltersSheet()
        .environmentObject(ActivityStore())
}

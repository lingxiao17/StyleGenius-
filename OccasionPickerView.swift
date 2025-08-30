//
//  OccasionPickerView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/28/25.
//

import SwiftUI

struct Occasion {
    let name: String
    let icon: String
    let description: String
    let color: Color
}

struct OccasionPickerView: View {
    @Binding var selectedOccasion: Occasion?
    @Binding var isPresented: Bool
    
    let occasions = [
        Occasion(name: "Work", icon: "briefcase", description: "Professional meetings and office", color: .blue),
        Occasion(name: "Date", icon: "heart", description: "Romantic dinner or special evening", color: .pink),
        Occasion(name: "Gym", icon: "figure.run", description: "Workout and fitness activities", color: .orange),
        Occasion(name: "Party", icon: "party.popper", description: "Celebrations and social events", color: .purple),
        Occasion(name: "Casual", icon: "house", description: "Everyday activities and relaxing", color: .green),
        Occasion(name: "Travel", icon: "airplane", description: "Comfortable for long trips", color: .teal)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Choose an Occasion")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                Text("Select the occasion to get personalized outfit suggestions")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(occasions.indices, id: \.self) { index in
                        OccasionCard(
                            occasion: occasions[index],
                            isSelected: selectedOccasion?.name == occasions[index].name
                        ) {
                            selectedOccasion = occasions[index]
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                if selectedOccasion != nil {
                    Button("Done") {
                        isPresented = false
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Select Occasion")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct OccasionCard: View {
    let occasion: Occasion
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: occasion.icon)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .white : occasion.color)
                
                Text(occasion.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(occasion.description)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? occasion.color : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? occasion.color : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}




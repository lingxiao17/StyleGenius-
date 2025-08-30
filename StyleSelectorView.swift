//
//  StyleSelectorView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/25/25.
//

import SwiftUI

struct StyleSelectorView: View {
    @State private var selectedStyles: Set<String> = []
    @State private var isSaving = false
    @State private var showingSaveSuccess = false
    
    let styleOptions = [
        StyleOption(name: "Casual", icon: "tshirt", description: "Relaxed, everyday comfort"),
        StyleOption(name: "Formal", icon: "suit", description: "Professional and elegant"),
        StyleOption(name: "Trendy", icon: "sparkles", description: "Latest fashion trends"),
        StyleOption(name: "Classic", icon: "crown", description: "Timeless and sophisticated"),
        StyleOption(name: "Sporty", icon: "figure.walk", description: "Athletic and active wear"),
        StyleOption(name: "Bohemian", icon: "leaf", description: "Free-spirited and artistic"),
        StyleOption(name: "Minimalist", icon: "minus.circle", description: "Clean and simple"),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Choose Your Style Preferences")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Select the styles that match your personality. You can choose multiple options to get more personalized outfit recommendations.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(styleOptions, id: \.name) { style in
                            StyleCard(
                                style: style,
                                isSelected: selectedStyles.contains(style.name)
                            ) {
                                toggleStyle(style.name)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if !selectedStyles.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Selected Styles")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(Array(selectedStyles), id: \.self) {style in
                                        Text(style)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                        
                        Button(action: savePreferences) {
                            HStack{
                                if isSaving {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                }
                                Text(isSaving ? "Saving..." : "Save Preferences")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Style Preferences")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func toggleStyle(_ styleName: String) {
        if selectedStyles.contains(styleName) {
            selectedStyles.remove(styleName)
        } else {
            selectedStyles.insert(styleName)
        }
    }
    
    func savePreferences() {
        isSaving = true
        // Simulate saving to a database or user defaults
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSaving = false
            showingSaveSuccess = true
            
            // Hide success message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showingSaveSuccess = false
                }
            }
        }
    }
    
    struct StyleOption {
        let name: String
        let icon: String
        let description: String
    }
    
    struct StyleCard: View {
        let style: StyleOption
        let isSelected: Bool
        let onTap: () -> Void
        
        var body: some View {
            Button(action: onTap) {
                VStack(spacing: 12) {
                    Image(systemName: style.icon)
                        .font(.title)
                        .foregroundColor(isSelected ? .white : .blue)
                    
                    VStack(spacing: 4) {
                        Text(style.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(isSelected ? .white : .primary)
                        
                        Text(style.description)
                            .font(.caption)
                            .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    
}


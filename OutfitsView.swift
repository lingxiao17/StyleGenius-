//
//  OutfitsView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/20/25.
//

import SwiftUI

struct OutfitItem {
    let id = UUID()
    let name: String
    let category: String
    let color: String
}

struct Outfit {
    let id = UUID()
    let name: String
    let occasion: String
    let items: [OutfitItem]
    let styleRating: Int
}

// Sample outfit data
let sampleOutfits = [
    Outfit(
        name: "Casual Weekend",
        occasion: "Casual",
        items: [
            OutfitItem(name: "White T-Shirt", category: "Top", color: "White"),
            OutfitItem(name: "Blue Jeans", category: "Bottom", color: "Blue"),
            OutfitItem(name: "White Sneakers", category: "Shoes", color: "White")
        ],
        styleRating: 4
    ),
    Outfit(
        name: "Business Meeting",
        occasion: "Professional",
        items: [
            OutfitItem(name: "Navy Blazer", category: "Top", color: "Navy"),
            OutfitItem(name: "White Shirt", category: "Under", color: "White"),
            OutfitItem(name: "Gray Trousers", category: "Bottom", color: "Gray"),
            OutfitItem(name: "Black Dress Shoes", category: "Shoes", color: "Black")
        ],
        styleRating: 5
    ),
    Outfit(
        name: "Date Night",
        occasion: "Evening",
        items: [
            OutfitItem(name: "Black Dress", category: "Dress", color: "Black"),
            OutfitItem(name: "Red Heels", category: "Shoes", color: "Red"),
            OutfitItem(name: "Gold Jewelry", category: "Accessories", color: "Gold")
        ],
        styleRating: 5
    )
]

struct SavedOutfit: Identifiable, Codable {
    var id = UUID()
    let recommendation: String
    let occasion: String
    let weather: String
    let style: String
    let dateSaved: Date
}


struct OutfitsView: View {
    @AppStorage("wardrobeCount") private var wardrobeItemCount: Int = 0

    @StateObject private var openAIService = OpenAIService()
    @State private var selectedOccasion = "Casual"
    @State private var selectedWeather = "Mild"
    @State private var selectedStyle = "Classic"
    @State private var generatedOutfit = ""
    @State private var isGenerating = false
    @State private var showingRecommendation = false
    
    @State private var savedOutfits: [SavedOutfit] = []
    @State private var showingSavedOutfits = false
    
    @State private var outfits = sampleOutfits  
    
    let occasions = ["Casual", "Work", "Formal", "Date Night", "Workout", "Weekend"]
    let weatherOptions = ["Cold", "Mild", "Warm", "Hot", "Rainy"]
    let stylePreferences = ["Classic", "Trendy", "Bohemian", "Minimalist", "Edgy", "Romantic"]
    
    private var wardrobeDescriptions: [String] {
        if wardrobeItemCount == 0 {
            return ["No items in wardrobe yet - add some clothing photos in the Wardrobe tab first"]
        } else {
            return (1...wardrobeItemCount).map { "Clothing item \($0) from your wardrobe" }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 15) {
                        Text("Get Your Perfect Outfit")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Tell me about your plans and I'll suggest the perfect combination from your wardrobe")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Occasion")
                                .font(.headline)
                            Picker("Occasion", selection: $selectedOccasion) {
                                ForEach(occasions, id: \.self) { occasion in
                                    Text(occasion).tag(occasion)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weather")
                                .font(.headline)
                            Picker("Weather", selection: $selectedWeather) {
                                ForEach(weatherOptions, id: \.self) { weather in
                                    Text(weather).tag(weather)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style Preference")
                                .font(.headline)
                            Picker("Style", selection: $selectedStyle) {
                                ForEach(stylePreferences, id: \.self) { style in
                                    Text(style).tag(style)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: generateOutfit) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            Text(isGenerating ? "Creating Your Outfit..." : "Generate Outfit Recommendation")
                        }
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isGenerating ? Color.gray : Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .disabled(isGenerating)
                                        
                    if showingRecommendation && !generatedOutfit.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Your Outfit Recommendation")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Spacer()
                                
                                Button("Save Outfit") {
                                    saveCurrentOutfit()
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            Text(generatedOutfit)
                                .font(.body)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    
                    Spacer(minLength: 50)
                }
            }
            .navigationTitle("My Outfits")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generateOutfit() {
        isGenerating = true
        showingRecommendation = false
        
        Task {
            do {
                let recommendation = try await openAIService.generateOutfitRecommendation(
                    wardrobeItems: wardrobeDescriptions,
                    occasion: selectedOccasion,
                    weather: selectedWeather,
                    stylePreference: selectedStyle
                )
                
                await MainActor.run {
                    generatedOutfit = recommendation
                    isGenerating = false
                    showingRecommendation = true
                }
            } catch {
                print("OpenAI API error: \(error.localizedDescription)") // For Xcode console
                await MainActor.run {
                    generatedOutfit = "Error: \(error.localizedDescription)"
                    isGenerating = false
                    showingRecommendation = true
                }
            }

        }
    }
    
    private func saveCurrentOutfit() {
        let outfit = SavedOutfit(
            recommendation: generatedOutfit,
            occasion: selectedOccasion,
            weather: selectedWeather,
            style: selectedStyle,
            dateSaved: Date()
        )
        savedOutfits.append(outfit)
    }
}

struct OutfitCard: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with outfit name and occasion
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(outfit.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(outfit.occasion)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // Style rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= outfit.styleRating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(star <= outfit.styleRating ? .yellow : .gray)
                    }
                }
            }
            
            // Clothing items list
            VStack(alignment: .leading, spacing: 6) {
                Text("Items:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                
                ForEach(outfit.items, id: \.id) { item in
                    HStack {
                        Circle()
                            .fill(colorFromString(item.color))
                            .frame(width: 12, height: 12)
                        
                        Text(item.name)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text(item.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "white": return .white
        case "black": return .black
        case "blue": return .blue
        case "red": return .red
        case "gray": return .gray
        case "navy": return .blue
        case "gold": return .yellow
        default: return .gray
        }
    }
}

struct OutfitDetailView: View {
    let outfit: Outfit
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header section
                VStack(alignment: .leading, spacing: 8) {
                    Text(outfit.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(outfit.occasion)
                            .font(.title3)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        HStack(spacing: 3) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= outfit.styleRating ? "star.fill" : "star")
                                    .font(.title3)
                                    .foregroundColor(star <= outfit.styleRating ? .yellow : .gray)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Items section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Outfit Items")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ForEach(outfit.items, id: \.id) { item in
                        HStack(spacing: 15) {
                            Circle()
                                .fill(colorFromString(item.color))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                
                                HStack {
                                    Text(item.category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(item.color)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("Outfit Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "white": return .white
        case "black": return .black
        case "blue": return .blue
        case "red": return .red
        case "gray": return .gray
        case "navy": return .blue
        case "gold": return .yellow
        default: return .gray
        }
    }
}

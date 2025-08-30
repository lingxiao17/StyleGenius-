//
//  CategoryPicker.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/22/25.
//

import SwiftUI

enum ClothingCategory: String, CaseIterable, Codable, Identifiable {  // Add Codable here
    case tops = "tops"
    case bottoms = "bottoms"
    case dresses = "dresses"
    case outerwear = "outerwear"
    case shoes = "shoes"
    case accessories = "accessories"
    
    var id: String { self.rawValue } 
    
    var displayName: String {
        switch self {
        case .tops: return "Tops"
        case .bottoms: return "Bottoms"
        case .dresses: return "Dresses"
        case .outerwear: return "Outerwear"
        case .shoes: return "Shoes"
        case .accessories: return "Accessories"
        }
    }
    
    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "trousers"
        case .dresses: return "dress"
        case .outerwear: return "coat"
        case .shoes: return "shoe"
        case .accessories: return "eyeglasses"
        }
    }
}

struct CategoryPicker: View {
    @Binding var selectedCategory: ClothingCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(ClothingCategory.allCases) { category in
                        CategoryButton(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoryButton: View {
    let category: ClothingCategory
        let isSelected: Bool
        let action: () -> Void
        
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(category.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

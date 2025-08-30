//
//  AddItemView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/22/25.
//

import SwiftUI

struct AddItemView: View {
    let image: UIImage
    @State private var selectedCategory: ClothingCategory = .tops
    //Used to exist the "Add Item" flow (used in cancel and add item)
    @Environment(\.dismiss) private var dismiss
    let onSave: (ClothingItem) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add to Wardrobe")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                
                CategoryPicker(selectedCategory: $selectedCategory)
                    .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 15) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.title3)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    
                    Button("Add Item") {
                        let newItem = ClothingItem(image: image, category: selectedCategory)
                        onSave(newItem)
                        dismiss()
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
        }
    }
}



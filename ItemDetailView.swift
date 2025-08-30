//
//  ItemDetailView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/24/25.
//

import SwiftUI
import UIKit

struct ItemDetailView: View {
    @State var item: ClothingItem
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var onDelete: () -> Void
    var onUpdate: (ClothingItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Large item image
                Image(uiImage: item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                // Item details
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(label: "Name", value: item.name ?? "New Item")
                    DetailRow(label: "Category", value: item.category.displayName)
                    DetailRow(label: "Color", value: (item.color ?? "").isEmpty ? "Not specified" : item.color!)

                    if let notes = item.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text(notes)
                                .font(.body)
                        }
                    }

                    
                    DetailRow(label: "Added", value: DateFormatter.shortDate.string(from: item.dateAdded))
                }
                .padding(.horizontal)
                
                // Action buttons
                VStack(spacing: 12) {
                    Button("Edit Item") {
                        showingEditSheet = true
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    
                    Button("Delete Item") {
                        showingDeleteAlert = true
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(item.name ?? "New Item")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingEditSheet) {
            EditItemView(item: $item) { updatedItem in
                onUpdate(updatedItem)
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.body)
            
            Spacer()
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}



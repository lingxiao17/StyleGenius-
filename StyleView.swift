//
//  StyleView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/20/25.
//

import SwiftUI

struct StyleView: View {
    @State private var selectedOccasion: Occasion?
    @State private var showingOccasionPicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("Style Preferences")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Customize your styling preferences for personalized recommendations")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    // Occasion Selection Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Occasion")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if let occasion = selectedOccasion {
                            HStack {
                                Image(systemName: occasion.icon)
                                    .font(.title2)
                                    .foregroundColor(occasion.color)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(occasion.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text(occasion.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button("Change") {
                                    showingOccasionPicker = true
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        } else {
                            Button("Select Occasion") {
                                showingOccasionPicker = true
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Style")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingOccasionPicker) {
            OccasionPickerView(selectedOccasion: $selectedOccasion, isPresented: $showingOccasionPicker)
        }
    }
}

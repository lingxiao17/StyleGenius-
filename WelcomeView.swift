//
//  WelcomeView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/20/25.
//

import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                Text("Welcome to StyleGenius")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Your AI buddy personal stylist")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 50)
            
            VStack(spacing: 20) {
                FeatureCard(icon:"tshirt", title: "Upload Your Wardrobe Items", description: "Take photos of your clothing items and build your digital closet")
                
                FeatureCard(icon: "sparkles", title: "Get AI Styling", description: "Receive personalized outfit suggestions based on your choice")
                
                FeatureCard(icon: "heart", title: "Save Favourites", description: "Save outfits you love and build personal style collection" )
            }
            .padding(.horizontal)
            
            Button("Get Started") {
                onGetStarted()
            }
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom, 30)
            
        }
        .padding()
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}




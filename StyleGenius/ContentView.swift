//
//  ContentView.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingWelcome = true
    
    var body: some View {
        if showingWelcome {
            WelcomeView(onGetStarted: {
                showingWelcome = false
            })
        } else {
            TabView {
                WardrobeView()
                    .tabItem {
                        Image(systemName: "tshirt")
                        Text("Wardrobe")
                    }
                OutfitsView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Outfits")
                    }
                StyleView()
                    .tabItem {
                        Image(systemName: "sparkles")
                        Text("Style")
                    }
            }
            
        }
        

    }
}



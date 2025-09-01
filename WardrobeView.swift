import SwiftUI
import UIKit
import PhotosUI

// SaveableClothingItem is now defined in WardrobeDataModel.swift

struct WardrobeView: View {
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var clothingItems: [ClothingItem] = []
    @State private var isProcessingImage = false
    @State private var showingSuccessMessage = false
    @State private var showingAddItemView = false
    @State private var selectedFilter: ClothingCategory? = nil
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    var searchFilteredItems: [ClothingItem] {
        let baseItems = selectedFilter != nil ? filteredItems : clothingItems
        
        if searchText.isEmpty {
            return baseItems
        } else {
            return baseItems.filter { item in
                item.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    struct WardrobeSearchBar: View {
        @Binding var searchText: String
        @Binding var isSearching: Bool
        
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search wardrobe...", text: $searchText)
                    .onTapGesture {
                        isSearching = true
                    }
                
                if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                        isSearching = false
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    
    
    //refresh function
    @State private var isRefreshing = false
    private func refreshWardrobe() async {
        isRefreshing = true
        // Simulate refresh delay for visual feedback
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRefreshing = false
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 15)
    ]
    
    var filteredItems: [ClothingItem] {
        if let filter = selectedFilter {
            return clothingItems.filter { $0.category == filter }
        } else {
            return clothingItems
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if !clothingItems.isEmpty {
                    CategoryFilterBar(selectedFilter: $selectedFilter)
                    WardrobeStats(clothingItems: clothingItems)
                    WardrobeSearchBar(searchText: $searchText, isSearching: $isSearching)
                }

                if filteredItems.isEmpty && !isProcessingImage {
                    VStack(spacing: 20) {
                        if clothingItems.isEmpty {
                            Text("My Wardrobe")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("Start building your digital closet by adding photos of your clothing items")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        } else {
                            Text("No items in this category")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)

                            Text("Try selecting a different category or add more items")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(searchFilteredItems, id: \.id) { item in
                                ClothingItemCard(
                                    item: item,
                                    onDelete: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if let originalIndex = clothingItems.firstIndex(where: { $0.id == item.id }) {
                                                clothingItems.remove(at: originalIndex)
                                                saveClothingItems()
                                            }
                                        }
                                    },
                                    onUpdate: { updatedItem in
                                        if let index = clothingItems.firstIndex(where: { $0.id == updatedItem.id }) {
                                            clothingItems[index] = updatedItem
                                            saveClothingItems()
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .refreshable { await refreshWardrobe() }
                }

                Spacer()

                // ✅ Move button modifiers here so sheet/dialog attach to VStack
                Button(isProcessingImage ? "Processing..." : "Add Clothing Item") {
                    if !isProcessingImage {
                        showingActionSheet = true
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isProcessingImage ? Color.gray : Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
                .disabled(isProcessingImage)
                .confirmationDialog("Add Photo", isPresented: $showingActionSheet, titleVisibility: .visible) {
                    Button("Take Photo") {
                        sourceType = .camera
                        showingImagePicker = true
                    }
                    Button("Choose from Library") {
                        sourceType = .photoLibrary
                        showingImagePicker = true
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("How would you like to add a photo of your clothing item?")
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker, sourceType: sourceType)
                }
            } // End VStack
            .navigationTitle("My Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                if isSearching {
                    hideKeyboard()
                    isSearching = false
                }
            }
            .overlay(alignment: .top) {
                if showingSuccessMessage {
                    Text("Item added to wardrobe! ✓")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: showingSuccessMessage)
                }
            }
            .onChange(of: selectedImage) { oldValue, newValue in
                if let image = newValue {
                    isProcessingImage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let newItem = ClothingItem(image: image, category: selectedFilter ?? .tops)
                        clothingItems.append(newItem)
                        saveClothingItems()
                        selectedImage = nil
                        isProcessingImage = false
                        showingSuccessMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showingSuccessMessage = false
                        }
                    }
                }
            }
            .onAppear { loadClothingItems() }
        } // End NavigationView
    }

private func saveClothingItems() {
    let encoder = JSONEncoder()
    do {
        let saveableItems = clothingItems.map { item in
            SaveableClothingItem(
                id: item.id,
                imageData: item.image.jpegData(compressionQuality: 0.8) ?? Data(),
                category: item.category,
                dateAdded: item.dateAdded,
                name: item.name,
                color: item.color,
                notes: item.notes
            )
        }
        let data = try encoder.encode(saveableItems)
        UserDefaults.standard.set(data, forKey: "clothingItems")
    } catch {
        print("Failed to save clothing items: \(error)")
    }
}

private func loadClothingItems() {
    let decoder = JSONDecoder()
    if let data = UserDefaults.standard.data(forKey: "clothingItems") {
        do {
            let saveableItems = try decoder.decode([SaveableClothingItem].self, from: data)
            clothingItems = saveableItems.compactMap { saveableItem -> ClothingItem? in
                guard let image = UIImage(data: saveableItem.imageData) else {
                    return nil
                }
                return ClothingItem(
                    image: image,
                    category: saveableItem.category
                )
            }
        } catch {
            print("Failed to load clothing items: \(error)")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
}

struct ClothingItemCard: View {
    let item: ClothingItem
    let onDelete: () -> Void
    let onUpdate: (ClothingItem) -> Void
    @State private var showingDeleteConfirmation = false
    @State private var showingItemDetail = false // Add this line
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                showingItemDetail = true // Add this button action
            }) {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipped()
                        .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: item.category.icon)
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Text(item.category.displayName)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(6)
                    .padding(8)
                }
            }
            .buttonStyle(PlainButtonStyle()) // Add this line
            
            Button(action: {
                showingDeleteConfirmation = true // Update this line
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .padding(5)
        }
        .sheet(isPresented: $showingItemDetail) {
                NavigationView {
                    ItemDetailView(
                        item: item,
                        onDelete: {
                            onDelete()
                            showingItemDetail = false
                        },
                        onUpdate: { updatedItem in
                            onUpdate(updatedItem) // Use the callback here
                            showingItemDetail = false
                        }
                    )
                }
            }
        .confirmationDialog("Delete Item", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove this item from your wardrobe?")
        }
    }
}

struct CategoryFilterBar: View {
    @Binding var selectedFilter: ClothingCategory?
    
    let categories: [ClothingCategory] = [.tops, .bottoms, .shoes, .accessories]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "All" button
                Button("All") {
                    selectedFilter = nil
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(selectedFilter == nil ? .white : .blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedFilter == nil ? Color.blue : Color.blue.opacity(0.1))
                .cornerRadius(20)
                
                // Category buttons
                ForEach(categories, id: \.self) { category in
                    Button(category.displayName) {
                        selectedFilter = category
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(selectedFilter == category ? .white : .blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(selectedFilter == category ? Color.blue : Color.blue.opacity(0.1))
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
        }
    }
}


struct WardrobeStats: View {
    let clothingItems: [ClothingItem]
    
    var categoryStats: [ClothingCategory: Int] {
        Dictionary(grouping: clothingItems, by: { $0.category })
            .mapValues { $0.count }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(clothingItems.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Total Items")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    ForEach(ClothingCategory.allCases) { category in
                        VStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.title3)
                                .foregroundColor(.blue)
                            
                            Text("\(categoryStats[category] ?? 0)")
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Text(category.displayName)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

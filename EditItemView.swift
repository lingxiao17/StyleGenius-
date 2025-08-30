import SwiftUI

struct EditItemView: View {
    @Binding var item: ClothingItem
    @Environment(\.dismiss) private var dismiss
    
    // Proper types
    @State private var name: String
    @State private var category: ClothingCategory
    @State private var color: String
    @State private var notes: String
    
    let onSave: (ClothingItem) -> Void
    
    let categories = ["Tops", "bottoms", "Dresses", "Outerwear", "Shoes", "Accessories"]
    
    init(item: Binding<ClothingItem>, onSave: @escaping (ClothingItem) -> Void) {
        self._item = item
        self.onSave = onSave
        
        // Initialize state safely
        self._name = State(initialValue: item.wrappedValue.name ?? "New Item")
        self._category = State(initialValue: item.wrappedValue.category)
        self._color = State(initialValue: item.wrappedValue.color ?? "")
        self._notes = State(initialValue: item.wrappedValue.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item Details") {
                    TextField("Item Name", text: $name)
                    
                    // Picker for enum category
                    Picker("Category", selection: $category) {
                        ForEach(ClothingCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    
                    TextField("Color", text: $color)
                }
                
                Section("Notes") {
                    TextField("Add notes about this item...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Update the item safely
                        var updatedItem = item
                        updatedItem.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        updatedItem.category = category
                        updatedItem.color = color.trimmingCharacters(in: .whitespacesAndNewlines)
                        updatedItem.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // Default name if empty
                        if updatedItem.name?.isEmpty ?? true {
                            updatedItem.name = "Untitled Item"
                        }
                        
                        onSave(updatedItem)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

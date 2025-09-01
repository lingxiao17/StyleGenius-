//
//  WardrobeDataModel.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/22/25.
//

import Foundation
import UIKit

// MARK: - Clothing Category Enum
enum ClothingCategory: String, CaseIterable, Codable, Identifiable {
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
    
    var iconName: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "pants"
        case .dresses: return "dress"
        case .outerwear: return "jacket"
        case .shoes: return "shoe"
        case .accessories: return "bag"
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

// MARK: - Clothing Item Model
struct ClothingItem {
    let id: UUID
    let image: UIImage
    var category: ClothingCategory
    let dateAdded: Date = Date()
    
    var name: String? = nil
    var color: String? = nil
    var notes: String? = nil
    
    init(image: UIImage, category: ClothingCategory, name: String = "New Item", color: String = "", notes: String = "") {
        self.id = UUID()
        self.image = image
        self.name = name
        self.category = category
        self.color = color
        self.notes = notes
    }
}

// MARK: - Saveable Clothing Item (for persistence)
struct SaveableClothingItem: Codable {
    let id: UUID
    let imageData: Data
    let category: ClothingCategory
    let dateAdded: Date
    let name: String?
    let color: String?
    let notes: String?
    
    init(id: UUID, imageData: Data, category: ClothingCategory, dateAdded: Date, name: String?, color: String?, notes: String?) {
        self.id = id
        self.imageData = imageData
        self.category = category
        self.dateAdded = dateAdded
        self.name = name
        self.color = color
        self.notes = notes
    }
    
    init(from clothingItem: ClothingItem) {
        self.id = clothingItem.id
        self.imageData = clothingItem.image.jpegData(compressionQuality: 0.8) ?? Data()
        self.category = clothingItem.category
        self.dateAdded = clothingItem.dateAdded
        self.name = clothingItem.name
        self.color = clothingItem.color
        self.notes = clothingItem.notes
    }
    
    func toClothingItem() -> ClothingItem? {
        guard let image = UIImage(data: imageData) else { return nil }
        
        var item = ClothingItem(image: image, category: category)
        item.name = name
        item.color = color
        item.notes = notes
        return item
    }
}

// MARK: - Outfit Model
struct Outfit: Identifiable, Codable {
    let id: UUID
    let name: String
    let items: [UUID] // References to clothing item IDs
    let occasion: String
    let style: String
    let dateCreated: Date
    let notes: String?
    
    init(name: String, items: [UUID], occasion: String, style: String, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.items = items
        self.occasion = occasion
        self.style = style
        self.dateCreated = Date()
        self.notes = notes
    }
}

// MARK: - Style Preferences
struct StylePreferences: Codable {
    var preferredColors: [String]
    var preferredStyles: [String]
    var occasions: [String]
    
    init() {
        self.preferredColors = []
        self.preferredStyles = []
        self.occasions = []
    }
}

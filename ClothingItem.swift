//
//  ClothingItem.swift
//  StyleGenius
//
//  Created by Lingchen Xiao on 8/22/25.
//
import UIKit
import Foundation

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

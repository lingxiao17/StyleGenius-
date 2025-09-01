# StyleGenius  
Your personal AI-powered digital stylist. Upload your wardrobe, explore outfit recommendations, and save your favorite looks.  

**Built solo using SwiftUI.**

---

## 📱 Screens & Demo  

<div align="center">
  <img src="screenshots/welcome.png" width="200"/>
  <img src="screenshots/wardrobe.png" width="200"/>
  <img src="screenshots/outfits.png" width="200"/>
</div>

**Quick Walkthrough:**  
1. Open the app  
2. Add items to your wardrobe  
3. Pick an occasion or style preference  
4. Get personalized outfit recommendations  

---

## ✨ Features  
- Upload clothing items via camera or photo library  
- Organize wardrobe by category (tops, bottoms, shoes, accessories)  
- Explore personalized outfit recommendations powered by AI  
- Select occasions and style preferences for tailored suggestions  
- Save and revisit favorite outfits  
- View AI-enhanced item details (colors, patterns, materials)  

---

## 🛠 Skills Demonstrated  
- Built reusable SwiftUI components (`FeatureCard`, `CategoryPicker`, `OutfitCard`)  
- Implemented navigation flows with `NavigationView` and `sheet`/`alert` modals  
- Integrated async/await with OpenAI API for dynamic recommendations  
- Developed item management with `@State`, `@Binding`, and `@ObservedObject`  
- Implemented custom image picker using `UIViewControllerRepresentable`  
- Designed grid-based layouts with `LazyVGrid` for wardrobes and outfit cards  
- Added lightweight filtering and search functionality across categories  
- Structured data models with enums and Codable (`ClothingCategory`, `ClothingItem`)  

---

## 🧰 Tech Stack  
- **Swift 5** 
- **SwiftUI:** Declarative UI framework  
- **Xcode:** 15+  
- **iOS Target:** iOS 17+  
- **Packages:**  
  - [OpenAI Swift SDK](https://github.com/adamrushy/OpenAISwift) — AI outfit generation  


## ⚡ Setup (Run in 2 Minutes)  
1. Clone the repo  
   ```bash
   git clone https://github.com/username/stylegenius.git
   cd stylegenius
2. Open StyleGenius.xcodeproj in Xcode
3. Add your OPENAI_API_KEY as an environment variable in the scheme
4. Run on simulator or device (iOS 17+)
---

## 🚀 Future Improvements  
- Persist wardrobe and saved outfits with Core Data or CloudKit  
- Enhance AI analysis with automated image detection (colors, patterns)  
- Add iOS widgets and Siri Shortcuts for quick outfit suggestions  
- Expand category options (outerwear, dresses, seasonal wear)  

---

## 🙌 Credits & Inspiration  
- Built using [CodeDreams](https://codedreams.app/)  
- Icons: Apple SF Symbols  
- Occasional styling references from fashion blogs & tutorials  

---

## 📄 License & Contact  
**License:** MIT  

**Author:** Lingchen Xiao  
- [LinkedIn](https://www.linkedin.com/in/lingchenxiao)  
- Email: lingchen@example.com  

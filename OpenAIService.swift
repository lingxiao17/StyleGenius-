import Foundation
import OpenAI

class OpenAIService: ObservableObject {
    private let apiKey = "REDACTEDproj-j2Ad3QlEbKZAC3bfCi-hlpi1bDam7gkmabZtLVoc-diEMnZqYUwqD-O-KLg1YH9FDvwdu1VAuZT3BlbkFJRDvuy647J3Gw2uGkxUdFNQDK5fBcji_qNaJTtElKJlx8Hpfcte_oQaM8IUIN5SL9IHmKBCDTcA"
    private var openAI: OpenAI
    
    init() {
        self.openAI = OpenAI(apiToken: apiKey)
    }
    
    func generateOutfitRecommendation(wardrobeItems: [String], occasion: String, weather: String, stylePreference: String) async throws -> String {
        let prompt = createOutfitPrompt(wardrobeItems: wardrobeItems, occasion: occasion, weather: weather, stylePreference: stylePreference)
        
        let query = ChatQuery(
            messages: [
                ChatQuery.ChatCompletionMessageParam(role: .system, content: "You are a professional fashion stylist and personal shopper. Provide helpful, specific outfit recommendations.")!,
                ChatQuery.ChatCompletionMessageParam(role: .user, content: prompt)!
            ], model: .gpt3_5Turbo
        )
        
        let result = try await openAI.chats(query: query)
        print("OpenAI response: \(result)")

        return result.choices.first?.message.content ?? "Sorry, I couldn't generate a recommendation right now."

    }
    
    private func createOutfitPrompt(wardrobeItems: [String], occasion: String, weather: String, stylePreference: String) -> String {
        return """
        Based on these wardrobe items: \(wardrobeItems.joined(separator: ", "))
        
        Please suggest a complete outfit for:
        - Occasion: \(occasion)
        - Weather: \(weather)
        - Style preference: \(stylePreference)
        
        Provide a specific outfit combination using only the items I have, and explain why this combination works well for the occasion and weather.
        """
    }
}

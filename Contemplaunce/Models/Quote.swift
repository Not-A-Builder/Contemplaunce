import Foundation

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
    let date: Date
}

extension Quote {
    static var previewTodayQuote: Quote {
        let philosopherQuote = QuoteCollection.randomQuote()
        return Quote(
            text: philosopherQuote.text,
            author: philosopherQuote.author,
            date: Date()
        )
    }
    
    static var previewQuotes: [Quote] = [
        Quote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius", date: Date()),
        Quote(text: "Waste no more time arguing about what a good man should be. Be one.", author: "Marcus Aurelius", date: Date()),
        Quote(text: "The best revenge is to be unlike him who performed the injury.", author: "Marcus Aurelius", date: Date())
    ]
} 

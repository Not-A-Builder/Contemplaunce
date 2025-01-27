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
    
    static var previewQuotes: [Quote] = []
} 

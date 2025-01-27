//
//  ContentView.swift
//  Contemplaunce
//
//  Created by Rounak Bose on 24/01/25.
//

import SwiftUI

// MARK: - Helper Views
struct ShimmerEffect: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .white.opacity(0.1),
                .white.opacity(0.3),
                .white.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .mask(Rectangle())
        .overlay(
            GeometryReader { geometry in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .white.opacity(0.5),
                                .clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(45))
                    .offset(x: -geometry.size.width)
                    .offset(x: phase * (geometry.size.width * 2))
            }
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

struct ThemeToggle: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isDarkMode.toggle()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: isDarkMode ? "circle.righthalf.filled" : "circle.lefthalf.filled")
                    .font(.system(size: 20))
                    .foregroundColor(isDarkMode ? .white : .black)
                    .rotationEffect(.degrees(isDarkMode ? 0 : 180))
                
                Text(isDarkMode ? "Yang" : "Yin")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDarkMode ? .white : .black)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isDarkMode ? Color.black : Color.white)
                    .shadow(color: isDarkMode ? .clear : .gray.opacity(0.15), radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isDarkMode ? Color.white.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct QuoteCard: View {
    let quote: Quote
    let isDarkMode: Bool
    @State private var isCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quote.text)
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
            
            HStack {
                Text(quote.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary.opacity(0.5))
                
                Spacer()
                
                Button(action: copyToClipboard) {
                    Image(systemName: isCopied ? "checkmark" : "square.on.square")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isDarkMode ? .white.opacity(0.5) : .gray.opacity(0.5))
                        .frame(width: 14, height: 14)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(isDarkMode ? Color.black : Color.white)
                .shadow(color: isDarkMode ? .white.opacity(0.05) : .gray.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isDarkMode ? Color.white.opacity(0.15) : Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = quote.text
        withAnimation {
            isCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                isCopied = false
            }
        }
    }
}

// MARK: - Main View
struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true {
        didSet {
            if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
                UserDefaults.standard.set(true, forKey: "isDarkMode")
            }
        }
    }
    @State private var quotes = Quote.previewQuotes
    @State private var todaysQuote = Quote.previewTodayQuote
    @State private var isCopied = false
    @State private var showGenerateButton = false
    @State private var isCircle = true
    @State private var circleSize: CGFloat = 24  // Changed from 20 to 24 (12px radius * 2)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Background color for the entire view
                (isDarkMode ? Color.black : Color.white)
                    .edgesIgnoringSafeArea(.all)
                
                // Main Content with Horizontal Paging
                TabView {
                    // First Page - Main Quote
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 32) {
                            Text(todaysQuote.author)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            GeometryReader { geo in
                                VStack(spacing: 24) {
                                    Text(todaysQuote.text)
                                        .font(.system(size: 42, weight: .medium, design: .serif))
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 40)
                                        .padding(.top, 40)
                                        .padding(.bottom, 20)
                                        .frame(maxWidth: .infinity)
                                        .frame(minHeight: 0, maxHeight: .infinity)
                                    
                                    copyButton
                                        .padding(.bottom, 4)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.height * 0.48)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(isDarkMode ? Color.black : Color.white)
                                        .shadow(color: isDarkMode ? .white.opacity(0.05) : .gray.opacity(0.15), radius: 15, x: 0, y: 5)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(isDarkMode ? Color.white.opacity(0.15) : Color.black.opacity(0.05), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.5)
                        }
                        .frame(maxHeight: .infinity)
                        
                        Spacer()
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height)
                    .tag(0)
                    
                    // Second Page - Previous Quotes
                    VStack {
                        Spacer(minLength: 60)
                        
                        Spacer(minLength: UIScreen.main.bounds.height * 0.0275)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 21) {
                                Text("✽")
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 52)
                                    .padding(.bottom, 7)
                                
                                ForEach(Array(quotes.enumerated()), id: \.element.id) { index, quote in
                                    QuoteCard(quote: quote, isDarkMode: isDarkMode)
                                }
                                
                                Spacer(minLength: UIScreen.main.bounds.height * 0.1)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Fixed Header - Theme Toggle with transparent background
                VStack {
                    ZStack(alignment: .top) {
                        // Top gradient background - made more gradual
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(UIColor.systemBackground),
                                    Color(UIColor.systemBackground),
                                    Color(UIColor.systemBackground).opacity(0.9),
                                    Color(UIColor.systemBackground).opacity(0.7),
                                    Color(UIColor.systemBackground).opacity(0.3),
                                    Color(UIColor.systemBackground).opacity(0.0)
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 180) // Increased height for more gradual fade
                        .allowsHitTesting(false)
                        
                        ThemeToggle(isDarkMode: $isDarkMode)
                            .padding(.top, 12)
                    }
                    
                    Spacer()
                }
                
                // Fixed Footer - CTA Button
                VStack {
                    Spacer()
                    bottomSection
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            // Each phase takes 1 second (8 seconds / 8 phases = 1s each)
            
            // Start first shrink
            withAnimation(.easeInOut(duration: 1.0)) {
                circleSize = 12
            }
            
            // First expand
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    circleSize = 24
                }
            }
            
            // Second shrink
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    circleSize = 12
                }
            }
            
            // Second expand
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    circleSize = 24
                }
            }
            
            // Third shrink
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    circleSize = 12
                }
            }
            
            // Third expand
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    circleSize = 24
                }
            }
            
            // Fourth shrink
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    circleSize = 12
                }
            }
            
            // Morph into button immediately after fourth shrink
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isCircle = false
                    showGenerateButton = true
                }
            }
        }
    }
    
    // MARK: - View Components
    private var copyButton: some View {
        Button(action: copyToClipboard) {
            Text(isCopied ? "Copied!" : "Copy")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isDarkMode ? .white.opacity(0.8) : .gray)
                .frame(height: 36) // Fixed height for the content
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                        .opacity(isCopied ? 0 : 1)  // Hide background when copied
                )
        }
        .padding(.bottom, 40)
    }
    
    private var bottomSection: some View {
        ZStack(alignment: .bottom) {
            // Bottom gradient background
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(UIColor.systemBackground),
                        Color(UIColor.systemBackground),
                        Color(UIColor.systemBackground).opacity(0.95),
                        Color(UIColor.systemBackground).opacity(0.0)
                    ]
                ),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 160)
            .padding(.bottom, -8)
            .allowsHitTesting(false)
            .opacity(isCircle ? 0 : 1)
            
            // Morphing Button
            Button(action: generateNewQuote) {
                ZStack {
                    RoundedRectangle(cornerRadius: isCircle ? circleSize/2 : 22)
                        .fill(isDarkMode ? .white : .black)
                        .frame(
                            width: isCircle ? circleSize : UIScreen.main.bounds.width * 0.75,
                            height: isCircle ? circleSize : 64
                        )
                        .offset(y: isCircle ? 4 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: isCircle ? circleSize/2 : 22)
                                .stroke(Color.white.opacity(isCircle ? 0 : 0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.purple.opacity(isCircle ? 0 : (isDarkMode ? 0.2 : 0.15)), radius: 10, x: -10, y: 10)
                        //.shadow(color: Color.teal.opacity(isCircle ? 0 : (isDarkMode ? 0.1125 : 0.15)), radius: 12, x: -8, y: 12)
                        .shadow(color: Color.orange.opacity(isCircle ? 0 : (isDarkMode ? 0.2 : 0.15)), radius: 12, x: 0, y: 15)
                        //.shadow(color: Color.blue.opacity(isCircle ? 0 : (isDarkMode ? 0.1125 : 0.15)), radius: 12, x: 8, y: 12)
                        .shadow(color: Color.blue.opacity(isCircle ? 0 : (isDarkMode ? 0.2 : 0.15)), radius: 10, x: 10, y: 10)
                    
                    if !isCircle {
                        Text("Generate new quote")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(isDarkMode ? .black : .white)
                            .opacity(0.999)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.75, height: 64)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Functions
    func copyToClipboard() {
        UIPasteboard.general.string = todaysQuote.text
        withAnimation {
            isCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                isCopied = false
            }
        }
    }
    
    func generateNewQuote() {
        // Store the current quote in the quotes history
        quotes.insert(todaysQuote, at: 0)
        
        // Generate a new quote using the updated QuoteCollection method
        let newQuote = QuoteCollection.randomQuote()
        
        // Update today's quote
        todaysQuote = Quote(
            text: newQuote.text,
            author: newQuote.author,
            date: Date()
        )
    }
}

// MARK: - Previews
/*#Preview("Quote Card") {
    QuoteCard(quote: Quote.previewQuotes[0], isDarkMode: false)
        .padding()
}

#Preview("Theme Toggle") {
    ThemeToggle(isDarkMode: .constant(false))
        .padding()
}*/

#Preview("Content View") {
    ContentView()
}

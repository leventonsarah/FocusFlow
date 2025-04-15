//
//  MotivationView.swift
//  TaskMaster
//
//  Created by YunXian Xu on 2025-04-06.
//

//API:
//ZIN QUOTE
//https://docs.zenquotes.io/
//https://docs.zenquotes.io/go-tutorial-retrieve-a-random-entry-from-the-zenquotes-api/

import SwiftUI

struct MotivationView: View {
    @State private var quotes: [Quote] = []
    @State private var currentIndex: Int = 0
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @State private var showingFavoritesView = false

    var body: some View {
        NavigationView { 
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.purple.opacity(0.6), .blue.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    Text("✨ Daily Motivation ✨")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    if quotes.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else {
                        TabView(selection: $currentIndex) {
                            ForEach(quotes.indices, id: \.self) { index in
                                QuoteCard(
                                    quote: quotes[index],
                                    isFavorite: favoritesViewModel.isFavorite(quotes[index]),
                                    toggleFavorite: {
                                        toggleFavorite(quotes[index])
                                    }
                                )
                                .padding(.horizontal, 24)
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .animation(.easeInOut, value: currentIndex)
                        .frame(height: 400)
                    }

                    Spacer()

//                    NavigationLink(destination: FavoritesView()) {
//                        HStack(spacing: 8) {
//                            Image(systemName: "heart.fill")
//                            Text("View Favorites")
//                        }
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 24)
//                        .background(Color.white.opacity(0.2))
//                        .cornerRadius(16)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                        )
//                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
//                    }
//                    .padding(.bottom, 30)
                    
                    Button(action: {
                        showingFavoritesView = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                            Text("View Favorites")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                    .sheet(isPresented: $showingFavoritesView) {
                        NavigationView {
                            FavoritesView()
                        }
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    loadQuotes()
                    favoritesViewModel.fetchFavoriteQuotes()
                }
            }
        }
    }

    func toggleFavorite(_ quote: Quote) {
        if favoritesViewModel.isFavorite(quote) {
            favoritesViewModel.deleteFavorite(quote: quote)
        } else {
            favoritesViewModel.saveFavoriteQuote(quote)
        }
    }

    func loadQuotes() {
        let urlString = "https://zenquotes.io/api/quotes"
        guard let url = URL(string: urlString) else {
            quotes = fallbackQuotes
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Quote].self, from: data) {
                    DispatchQueue.main.async {
                        quotes = decodedResponse.isEmpty ? fallbackQuotes : decodedResponse
                    }
                } else {
                    DispatchQueue.main.async {
                        quotes = fallbackQuotes
                    }
                }
            } else {
                DispatchQueue.main.async {
                    quotes = fallbackQuotes
                }
            }
        }.resume()
    }

    let fallbackQuotes: [Quote] = [
        Quote(q: "Believe you can and you're halfway there.", a: "Theodore Roosevelt", h: nil),
        Quote(q: "Your time is limited, so don't waste it living someone else's life.", a: "Steve Jobs", h: nil),
        Quote(q: "Success is not final, failure is not fatal: It is the courage to continue that counts.", a: "Winston Churchill", h: nil)
    ]
}

struct QuoteCard: View {
    let quote: Quote
    var isFavorite: Bool
    var toggleFavorite: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("\"\(quote.q)\"")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)

            Text("- \(quote.a)")
                .font(.headline)
                .foregroundColor(.secondary)

            Button(action: toggleFavorite) {
                Label(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: isFavorite ? "heart.fill" : "heart"
                )
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct MotivationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MotivationView()
        }
    }
}

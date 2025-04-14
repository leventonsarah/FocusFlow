//
//  FavoritesView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-13.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple.opacity(0.6), .blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Your Favorite Quotes")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 50)

                if viewModel.favorites.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white.opacity(0.7))
                        Text("No favorites yet!")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.favorites) { quote in
                                QuoteCard(
                                    quote: quote,
                                    isFavorite: true,
                                    toggleFavorite: {
                                        viewModel.deleteFavorite(quote: quote)
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }

                Spacer()
            }
            .onAppear {
                viewModel.fetchFavoriteQuotes()
            }
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteFavorite(quote: viewModel.favorites[index])
        }
    }
}

#Preview {
    FavoritesView()
}

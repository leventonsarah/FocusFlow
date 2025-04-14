//
//  FavoritesViewModel.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-13.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FavoritesViewModel: ObservableObject {
    private let db = Firestore.firestore()

    private var userID: String {
        Auth.auth().currentUser?.uid ?? "anonymous"
    }

    @Published var favorites: [Quote] = []

    func fetchFavoriteQuotes() {
        db.collection("users").document(userID).collection("favorites")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching favorites: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.favorites = documents.compactMap { doc in
                    try? doc.data(as: Quote.self)
                }
            }
    }

    func saveFavoriteQuote(_ quote: Quote) {
        do {
            _ = try db.collection("users").document(userID).collection("favorites").document(quote.q)
                .setData(from: quote)
            
            DispatchQueue.main.async {
                self.favorites.append(quote)
            }
        } catch {
            print("Error saving favorite: \(error)")
        }
    }

    func deleteFavorite(quote: Quote) {
        db.collection("users").document(userID).collection("favorites").document(quote.q).delete { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.favorites.removeAll { $0 == quote }
                }
            } else {
                print("Error deleting: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func isFavorite(_ quote: Quote) -> Bool {
        favorites.contains(quote)
    }
}

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

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Daily Motivation")
                    .font(.largeTitle.bold())
                    .padding(.top, 50)

                if quotes.isEmpty {
                    ProgressView()
                } else {
                    TabView(selection: $currentIndex) {
                        ForEach(quotes.indices, id: \.self) { index in
                            QuoteCard(quote: quotes[index])
                                .padding()
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .animation(.easeInOut, value: currentIndex)
                }

                Spacer()
            }
            .onAppear(perform: loadQuotes)
        }
    }

    func loadQuotes() {
        let urlString = "https://zenquotes.io/api/quotes"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Quote].self, from: data) {
                    DispatchQueue.main.async {
                        quotes = decodedResponse.isEmpty ? fallbackQuotes : decodedResponse
                    }
                }
            }
        }.resume()
    }

    let fallbackQuotes: [Quote] = [
        Quote(q: "Believe you can and you're halfway there.", a: "Theodore Roosevelt"),
        Quote(q: "Your time is limited, so don't waste it living someone else's life.", a: "Steve Jobs"),
        Quote(q: "Success is not final, failure is not fatal: It is the courage to continue that counts.", a: "Winston Churchill")
    ]
}

struct QuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 16) {
            Text("\"\(quote.q)\"")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()

            Text("- \(quote.a)")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct Quote: Codable {
    var q: String
    var a: String
}

struct MotivationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MotivationView()
        }
    }
}

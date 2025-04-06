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
    @State private var quote: String = "Loading..."
    @State private var author: String = ""

    var body: some View {
        VStack {
            Text("\"\(quote)\"")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
                .multilineTextAlignment(.center)
            
            Text("- \(author)")
                .font(.headline)
                .padding(.top, 5)

            Spacer()
        }
        .onAppear(perform: loadQuote)
        .navigationTitle("Motivation")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func loadQuote() {
        let urlString = "https://zenquotes.io/api/random"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Quote].self, from: data) {
                    DispatchQueue.main.async {
                        quote = decodedResponse.first?.q ?? "No quote found"
                        author = decodedResponse.first?.a ?? "Unknown"
                    }
                }
            }
        }.resume()
    }
}

struct Quote: Codable {
    var q: String  // quote
    var a: String  // author
}



struct MotivationView_Previews: PreviewProvider {
    static var previews: some View {
        MotivationView()
    }
}

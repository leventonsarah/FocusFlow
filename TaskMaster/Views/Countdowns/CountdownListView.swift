//
//  CountdownListView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation
import SwiftUI

import SwiftUI

struct CountdownListView: View {
    @StateObject var viewModel = CountdownViewModel()
    @State private var showingAddView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.events.sorted { $0.date < $1.date }) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)

                        HStack {
                            Text(event.category)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Spacer()

                            Text("D-\(Calendar.current.dateComponents([.day], from: Date(), to: event.date).day ?? 0)")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Countdowns")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddCountdownView(viewModel: viewModel)
            }
        }
    }
}

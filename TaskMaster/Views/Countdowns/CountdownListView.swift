//
//  CountdownListView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation
import SwiftUI

struct CountdownListView: View {
    @StateObject var viewModel = CountdownViewModel()
    @State private var showingAddView = false
    @State private var showingEditView = false
    @State private var selectedEvent: Countdown?

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
                    .onTapGesture {
                        selectedEvent = event
                        showingEditView = true
                    }
                }
                .onDelete(perform: deleteEvent)
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
            .sheet(isPresented: $showingEditView) {
                if let selectedEvent = selectedEvent {
                    EditCountdownView(viewModel: viewModel, event: selectedEvent)
                }
            }
        }
    }

    func deleteEvent(at offsets: IndexSet) {
        for index in offsets {
            let event = viewModel.events.sorted { $0.date < $1.date }[index]
            viewModel.deleteEvent(event)
        }
    }
}

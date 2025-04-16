//
//  EditCountdownView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation
import SwiftUI

struct EditCountdownView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CountdownViewModel

    var event: Countdown

    @State private var title: String
    @State private var date: Date
    @State private var category: String
    @State private var showOnHome: Bool

    let categories = ["Midterm", "Final", "Project", "Other"]

    init(viewModel: CountdownViewModel, event: Countdown) {
        self.viewModel = viewModel
        self.event = event
        _title = State(initialValue: event.title)
        _date = State(initialValue: event.date)
        _category = State(initialValue: event.category)
        _showOnHome = State(initialValue: event.showOnHome)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Event")) {
                    TextField("Title", text: $title)

                    DatePicker("Date", selection: $date, displayedComponents: [.date])

                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }

                    Toggle("Show on Home", isOn: $showOnHome)
                }

                Button("Save Changes") {
                    let updatedEvent = Countdown(
                        id: event.id,
                        title: title,
                        date: date,
                        category: category,
                        showOnHome: showOnHome
                    )
                    viewModel.updateEvent(updatedEvent)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Edit Countdown")
        }
    }
}

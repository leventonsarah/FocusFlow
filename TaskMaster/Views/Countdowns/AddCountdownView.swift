//
//  AddCountdownView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation
import SwiftUI

import SwiftUI

struct AddCountdownView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CountdownViewModel

    @State private var title = ""
    @State private var date = Date()
    @State private var category = "Midterm"
    @State private var showOnHome = false

    let categories = ["Midterm", "Final", "Project", "Other"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)

                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }

                    Toggle("Show on Home", isOn: $showOnHome)
                }

                Button("Save") {
                    let newEvent = Countdown(
                        title: title,
                        date: date,
                        category: category,
                        showOnHome: showOnHome
                    )
                    viewModel.addEvent(newEvent)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            }
            .navigationTitle("New Countdown")
        }
    }
}

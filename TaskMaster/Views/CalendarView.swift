//
//  CalendarView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import SwiftUI
import UserNotifications

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var newEventTitle = ""

    @StateObject private var eventViewModel = EventViewModel()

    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .tint(.blue)
            .padding()

            DatePicker(
                "Select Time",
                selection: $selectedDate,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.compact)
            .padding(.horizontal)

            List {
                Section(header: Text("Events on \(selectedDate.formatted(date: .abbreviated, time: .omitted))")) {
                    ForEach(eventViewModel.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { event in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                Text(event.date.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(role: .destructive) {
                                eventViewModel.deleteEvent(event)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .animation(.spring(), value: eventViewModel.events)

            HStack {
                TextField("New Event", text: $newEventTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Add") {
                    eventViewModel.addEvent(title: newEventTitle, date: selectedDate)
                    newEventTitle = ""
                }
                .disabled(newEventTitle.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Calendar")
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

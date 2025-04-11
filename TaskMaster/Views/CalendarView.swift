//
//  CalendarView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import SwiftUI
import Foundation
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
                                deleteEvent(event)
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
                    addEvent()
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

    func addEvent() {
        let event = Event(title: newEventTitle, date: selectedDate)
        eventViewModel.addEvent(event) 
        newEventTitle = ""
    }


    func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Event: \(event.title)"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    func deleteEvent(_ event: Event) {
        eventViewModel.deleteEvent(event)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

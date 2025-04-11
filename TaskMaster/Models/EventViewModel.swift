//
//  EventViewModel.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-08.
//

import Foundation
import FirebaseFirestore
import UserNotifications

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var db = Firestore.firestore()

    init() {
        fetchEvents()
    }

    func fetchEvents() {
        db.collection("events").order(by: "date").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.events = documents.compactMap { try? $0.data(as: Event.self) }
        }
    }

    func addEvent(_ event: Event) {
        do {
            let docRef = try db.collection("events").addDocument(from: event)
            scheduleNotification(for: event, id: docRef.documentID)
        } catch {
            print("Error adding event: \(error)")
        }
    }


    func deleteEvent(_ event: Event) {
        guard let id = event.id else { return }
        db.collection("events").document(id).delete()
        removeNotification(id: id)
    }

    func scheduleNotification(for event: Event, id: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = "Event Reminder"
        content.body = event.title
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.date)
        
        guard let triggerDateTime = Calendar.current.date(from: triggerDate), triggerDateTime > Date() else {
            print("Event time is in the past, notification won't be scheduled.")
            return
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: id ?? UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

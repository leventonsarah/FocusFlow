//
//  CountdownViewModel.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CountdownViewModel: ObservableObject {
    @Published var events: [Countdown] = []

    private var db = Firestore.firestore()

    var upcomingHomeEvent: Countdown? {
        return events
            .filter { $0.showOnHome && $0.date >= Date() }
            .sorted { $0.date < $1.date }
            .first
    }

    init() {
        fetchEvents() // ✅ Add this line to load countdowns when ViewModel is created
    }

    func addEvent(_ event: Countdown) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let data: [String: Any] = [
            "title": event.title,
            "date": Timestamp(date: event.date),
            "category": event.category,
            "showOnHome": event.showOnHome
        ]

        db.collection("users").document(uid).collection("countdowns").addDocument(data: data) { error in
            if let error = error {
                print("❌ Error saving countdown: \(error.localizedDescription)")
            } else {
                self.fetchEvents() // ✅ Refresh the list after adding
            }
        }
    }

    func fetchEvents() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).collection("countdowns")
            .order(by: "date")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching countdowns: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.events = documents.compactMap { doc -> Countdown? in
                    var data = doc.data()
                    data["id"] = doc.documentID // ✅ Add the Firestore doc ID to the data
                    return Countdown(from: data)
                }
            }
    }
}

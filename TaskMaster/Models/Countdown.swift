//
//  CountdownEvent.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct Countdown: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var category: String
    var showOnHome: Bool

    var dictionary: [String: Any] {
        return [
            "id": id,
            "title": title,
            "date": Timestamp(date: date),
            "category": category,
            "showOnHome": showOnHome
        ]
    }

    init(id: String = UUID().uuidString, title: String, date: Date, category: String, showOnHome: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.category = category
        self.showOnHome = showOnHome
    }

    init?(from dict: [String: Any]) {
        guard
            let title = dict["title"] as? String,
            let timestamp = dict["date"] as? Timestamp,
            let category = dict["category"] as? String,
            let showOnHome = dict["showOnHome"] as? Bool
        else { return nil }

        self.id = dict["id"] as? String ?? UUID().uuidString
        self.title = title
        self.date = timestamp.dateValue()
        self.category = category
        self.showOnHome = showOnHome
    }
}

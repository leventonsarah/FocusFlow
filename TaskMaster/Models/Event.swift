//
//  Event.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-08.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var date: Date
    var userId: String

    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.date == rhs.date &&
        lhs.userId == rhs.userId
    }
}

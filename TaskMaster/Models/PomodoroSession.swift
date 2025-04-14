//
//  StudySession.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-11.
//

import Foundation
import FirebaseFirestore

struct PomodoroSession: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var sessionDate: Date
    var duration: Int
    var isBreak: Bool
    var reminders: [String]
}

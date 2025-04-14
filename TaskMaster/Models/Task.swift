//
//  Task.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct Task: Identifiable, Codable {
    @DocumentID var id: String?  
    var title: String
    var dueDate: Date
    var isCompleted: Bool
    var priority: Int
    var userId: String
}

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
}

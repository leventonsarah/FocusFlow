//
//  Quote.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-13.
//

import Foundation
import FirebaseFirestore

struct Quote: Codable, Identifiable, Equatable {
    var id: String { q + a }
    let q: String
    let a: String
    let h: String? 
}

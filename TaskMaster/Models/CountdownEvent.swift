//
//  CountdownEvent.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation

struct CountdownEvent: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: Date
    var category: String
    var showOnHome: Bool
}

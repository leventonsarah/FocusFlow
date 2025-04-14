//
//  Calendar.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-11.
//

import Foundation

extension Calendar {
    func isDateInLastWeek(_ date: Date) -> Bool {
        let now = Date()

        let startOfWeek = self.date(byAdding: .day, value: -7, to: now)!

        return date >= startOfWeek && date <= now
    }
}

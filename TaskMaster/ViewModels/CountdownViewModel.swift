//
//  CountdownViewModel.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-15.
//

import Foundation

class CountdownViewModel: ObservableObject {
    @Published var events: [CountdownEvent] = []

    var upcomingHomeEvent: CountdownEvent? {
        return events
            .filter { $0.showOnHome && $0.date >= Date() }
            .sorted { $0.date < $1.date }
            .first
    }

    func addEvent(_ event: CountdownEvent) {
        events.append(event)
    }
}

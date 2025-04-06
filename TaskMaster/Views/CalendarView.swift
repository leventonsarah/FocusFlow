//
//  CalendarView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Text("Selected Day: \(selectedDate.formatted(date: .long, time: .omitted))")
                .font(.title3)
                .padding()
        }
        .navigationTitle("Calendar")
    }
}

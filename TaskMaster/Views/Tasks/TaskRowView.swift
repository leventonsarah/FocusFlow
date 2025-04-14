//
//  TaskRowView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI

struct TaskRowView: View {
    let task: Task
    let toggleComplete: () -> Void
    
    func priorityColor(for priority: Int) -> Color {
        switch priority {
            case 0: return .green
            case 1: return .yellow
            case 2: return .red
            default: return .gray
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title).font(.headline)
                
                HStack {
                    Circle()
                        .fill(priorityColor(for: task.priority))
                        .frame(width: 10, height: 10)
                    
                    Text("Due: \(task.dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: toggleComplete) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
        }
        .padding(.vertical, 6)
    }
}


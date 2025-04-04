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

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title).font(.headline)
                Text("Due: \(task.dueDate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
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

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task(title: "Sample Task", dueDate: Date(), isCompleted: false, priority: 1)) {
            print("Task toggled")
        }
        .previewLayout(.sizeThatFits)
    }
}

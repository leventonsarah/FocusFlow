//
//  TaskListView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tasks) { task in
                    TaskRowView(task: task) {
                        viewModel.toggleCompletion(for: task)
                    }
                }
                .onDelete(perform: viewModel.deleteTask)
            }
            .navigationTitle("Tasks")
            .toolbar {
                NavigationLink(destination: AddTaskView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

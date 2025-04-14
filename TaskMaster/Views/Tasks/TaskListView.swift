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
                Section(header: Text("Incomplete Tasks")) {
                    ForEach(viewModel.tasks.filter { !$0.isCompleted }) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleCompletion(for: task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                
                Section(header: Text("Completed Tasks")) {
                    ForEach(viewModel.tasks.filter { $0.isCompleted }) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleCompletion(for: task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
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

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
            .preferredColorScheme(.light)
    }
}

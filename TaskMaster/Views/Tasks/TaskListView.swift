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
    @State private var showingAddTaskView = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Incomplete To-Dos")) {
                    ForEach(viewModel.tasks.filter { !$0.isCompleted }) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleCompletion(for: task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                
                Section(header: Text("Completed To-Dos")) {
                    ForEach(viewModel.tasks.filter { $0.isCompleted }) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleCompletion(for: task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTaskView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTaskView) {
                NavigationView {
                    AddTaskView(viewModel: viewModel)
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

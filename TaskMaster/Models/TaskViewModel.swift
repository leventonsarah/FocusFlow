//
//  TaskViewModel.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private var db = Firestore.firestore()

    init() {
        fetchTasks()
    }

    func fetchTasks() {
        db.collection("tasks").order(by: "dueDate").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            self.tasks = documents.compactMap { doc -> Task? in
                try? doc.data(as: Task.self)
            }
        }
    }

    func addTask(_ task: Task) {
        do {
            _ = try db.collection("tasks").addDocument(from: task)
        } catch {
            print("Error adding task: \(error)")
        }
    }

    func toggleCompletion(for task: Task) {
        guard let id = task.id else { return }
        let updatedTask = Task(id: id, title: task.title, dueDate: task.dueDate, isCompleted: !task.isCompleted, priority: task.priority)
        do {
            try db.collection("tasks").document(id).setData(from: updatedTask)
        } catch {
            print("Error updating task: \(error)")
        }
    }

    func deleteTask(at offsets: IndexSet) {
        offsets.map { tasks[$0] }.forEach { task in
            if let id = task.id {
                db.collection("tasks").document(id).delete()
            }
        }
    }
}

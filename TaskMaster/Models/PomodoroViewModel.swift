//
//  StudyViewModel.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-11.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PomodoroViewModel: ObservableObject {
    @Published var reminders: [String] = []
    @Published var pomodoroCount = 0
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
    init() {
            fetchSessions()
    }

    func fetchSessions() {
        guard let userId = auth.currentUser?.uid else {
            print("No user logged in")
            return
        }

        db.collection("pomodoroSessions")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No pomodoro session documents found")
                    return
                }

                let sessions = documents.compactMap { doc -> PomodoroSession? in
                    try? doc.data(as: PomodoroSession.self)
                }

                self.pomodoroCount = sessions.count
            }
    }

    func addReminder(_ reminder: String) {
        reminders.append(reminder)
    }
    
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
    
    func saveSession(duration: Int, isBreak: Bool) {
        guard let userId = auth.currentUser?.uid else {
            print("No user logged in")
            return
        }

        let session = PomodoroSession(
            userId: userId,
            sessionDate: Date(),
            duration: duration,
            isBreak: isBreak,
            reminders: reminders
        )

        do {
            _ = try db.collection("pomodoroSessions").addDocument(from: session) { error in
                if let error = error {
                    print("Failed to save session: \(error.localizedDescription)")
                } else {
                    print("Pomodoro session saved")
                }
            }
            pomodoroCount += 1
        } catch {
            print("Error encoding session: \(error)")
        }
    }
}

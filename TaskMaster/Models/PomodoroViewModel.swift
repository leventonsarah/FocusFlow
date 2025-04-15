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

enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"

    var id: String { rawValue }
}

class PomodoroViewModel: ObservableObject {
    @Published var reminders: [String] = []
    @Published var pomodoroCount = 0
    @Published var breakCount = 0
    @Published var dailyGoal: Int = 4
    @Published var selectedPeriod: AnalyticsPeriod = .day
    @Published var pomodorosPerDay: [String: Int] = [:]
    var sortedPomodoroData: [(String, Int)] {
        pomodorosPerDay.sorted { $0.key < $1.key }
    }

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

                let now = Date()
                let calendar = Calendar.current

                let filteredSessions = documents.compactMap {
                    try? $0.data(as: PomodoroSession.self)
                }.filter { session in
                    switch self.selectedPeriod {
                    case .day:
                        return calendar.isDate(session.sessionDate, inSameDayAs: now)
                    case .week:
                        return calendar.isDate(session.sessionDate, equalTo: now, toGranularity: .weekOfYear)
                    case .month:
                        return calendar.isDate(session.sessionDate, equalTo: now, toGranularity: .month)
                    }
                }

                self.pomodoroCount = filteredSessions.filter { !$0.isBreak }.count
                self.breakCount = filteredSessions.filter { $0.isBreak }.count

                var dailyCount: [String: Int] = [:]
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE"

                for session in filteredSessions where !session.isBreak {
                    let dayString = formatter.string(from: session.sessionDate)
                    dailyCount[dayString, default: 0] += 1
                }

                DispatchQueue.main.async {
                    self.pomodorosPerDay = dailyCount
                }
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

            if isBreak {
                breakCount += 1
            } else {
                pomodoroCount += 1
            }

        } catch {
            print("Error encoding session: \(error)")
        }
    }
}

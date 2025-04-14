//import SwiftUI
//
//struct AnalyticsView: View {
//    @ObservedObject var taskViewModel: TaskViewModel
//    @ObservedObject var pomodoroViewModel: PomodoroViewModel
//    
//    var totalTasks: Int {
//        return viewModel.tasks.count
//    }
//    
//    var completedTasks: Int {
//        return viewModel.tasks.filter { $0.isCompleted }.count
//    }
//    
//    var incompleteTasks: Int {
//        return viewModel.tasks.filter { !$0.isCompleted }.count
//    }
//    
//    var completedPercentage: Double {
//        guard totalTasks > 0 else { return 0 }
//        return (Double(completedTasks) / Double(totalTasks)) * 100
//    }
//    
//    var incompletePercentage: Double {
//        return 100 - completedPercentage
//    }
//    
//    var totalStudyTime: Int {
//        pomodoroViewModel.sessions.filter { !$0.isBreak }.map { $0.duration }.reduce(0, +)
//    }
//
//    var totalBreakTime: Int {
//        pomodoroViewModel.sessions.filter { $0.isBreak }.map { $0.duration }.reduce(0, +)
//    }
//
//    var totalSessions: Int {
//        pomodoroViewModel.sessions.count
//    }
//
//    var focusSessions: Int {
//        pomodoroViewModel.sessions.filter { !$0.isBreak }.count
//    }
//
//    var breakSessions: Int {
//        totalSessions - focusSessions
//    }
//
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Task Analytics")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                    .padding([.top, .leading])
//                
//                // Completed vs Incomplete Task Cards
//                HStack(spacing: 20) {
//                    AnalyticsCard(title: "Completed Tasks", value: completedTasks, total: totalTasks, percentage: completedPercentage, color: .green)
//                    AnalyticsCard(title: "Incomplete Tasks", value: incompleteTasks, total: totalTasks, percentage: incompletePercentage, color: .red)
//                }
//                .padding([.leading, .trailing])
//                
//                // Detailed Progress
//                VStack(alignment: .leading, spacing: 15) {
//                    ProgressSection(title: "Completed Tasks", value: completedTasks, total: totalTasks, color: .green)
//                    ProgressSection(title: "Incomplete Tasks", value: incompleteTasks, total: totalTasks, color: .red)
//                }
//                .padding([.leading, .trailing])
//            }
//            .cornerRadius(20)
//            .padding()
//        }
//        .navigationTitle("Analytics")
//    }
//}
//
//struct AnalyticsCard: View {
//    var title: String
//    var value: Int
//    var total: Int
//    var percentage: Double
//    var color: Color
//    
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.secondary)
//            Text("\(value) / \(total)")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(color)
//            ProgressBar(value: percentage, color: color)
//                .frame(height: 10)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
//    }
//}
//
//struct ProgressBar: View {
//    var value: Double
//    var color: Color
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Rectangle()
//                    .frame(height: 10)
//                    .cornerRadius(5)
//                    .foregroundColor(.gray.opacity(0.2))
//                
//                Rectangle()
//                    .frame(width: geometry.size.width * CGFloat(value / 100), height: 10)
//                    .cornerRadius(5)
//                    .foregroundColor(color)
//            }
//        }
//        .frame(height: 10)
//    }
//}
//
//struct ProgressSection: View {
//    var title: String
//    var value: Int
//    var total: Int
//    var color: Color
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.subheadline)
//                .fontWeight(.medium)
//                .foregroundColor(.secondary)
//            
//            HStack {
//                Text("\(value) / \(total)")
//                    .font(.headline)
//                Spacer()
//                Text(String(format: "%.0f%%", (Double(value) / Double(total)) * 100))
//                    .font(.subheadline)
//                    .foregroundColor(color)
//            }
//            .padding(.vertical, 5)
//            
//            ProgressBar(value: (Double(value) / Double(total)) * 100, color: color)
//        }
//        .padding(.vertical, 10)
//    }
//}
//
//struct AnalyticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyticsView(taskViewModel: TaskViewModel(), pomodoroViewModel: PomodoroViewModel())
//    }
//}

import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var pomodoroViewModel: PomodoroViewModel

    var totalTasks: Int {
        return taskViewModel.tasks.count
    }

    var completedTasks: Int {
        return taskViewModel.tasks.filter { $0.isCompleted }.count
    }

    var incompleteTasks: Int {
        return taskViewModel.tasks.filter { !$0.isCompleted }.count
    }

    var completedPercentage: Double {
        guard totalTasks > 0 else { return 0 }
        return (Double(completedTasks) / Double(totalTasks)) * 100
    }

    var incompletePercentage: Double {
        return 100 - completedPercentage
    }

    var totalPomodoros: Int {
        return pomodoroViewModel.pomodoroCount
    }

    var totalReminders: Int {
        return pomodoroViewModel.reminders.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Task Analytics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding([.top, .leading])

                HStack(spacing: 20) {
                    AnalyticsCard(title: "Completed Tasks", value: completedTasks, total: totalTasks, percentage: completedPercentage, color: .green)
                    AnalyticsCard(title: "Incomplete Tasks", value: incompleteTasks, total: totalTasks, percentage: incompletePercentage, color: .red)
                }
                .padding([.leading, .trailing])

                VStack(alignment: .leading, spacing: 15) {
                    ProgressSection(title: "Completed Tasks", value: completedTasks, total: totalTasks, color: .green)
                    ProgressSection(title: "Incomplete Tasks", value: incompleteTasks, total: totalTasks, color: .red)
                }
                .padding([.leading, .trailing])

                Divider().padding(.horizontal)

                Text("Study Analytics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding([.top, .leading])

                HStack(spacing: 20) {
                    AnalyticsCard(title: "Pomodoro Sessions", value: totalPomodoros, total: totalPomodoros, percentage: 100, color: .blue)
                    AnalyticsCard(title: "Active Reminders", value: totalReminders, total: totalReminders, percentage: 100, color: .orange)
                }
                .padding([.leading, .trailing])

                VStack(alignment: .leading, spacing: 15) {
                    ProgressSection(title: "Total Pomodoros Completed", value: totalPomodoros, total: totalPomodoros, color: .blue)
                    ProgressSection(title: "Total Active Reminders", value: totalReminders, total: totalReminders, color: .orange)
                }
                .padding([.leading, .trailing])
            }
            .cornerRadius(20)
            .padding()
        }
        .navigationTitle("Analytics")
    }
}

struct AnalyticsCard: View {
    var title: String
    var value: Int
    var total: Int
    var percentage: Double
    var color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text("\(value) / \(total)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            ProgressBar(value: percentage, color: color)
                .frame(height: 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
    }
}

struct ProgressBar: View {
    var value: Double
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 10)
                    .cornerRadius(5)
                    .foregroundColor(.gray.opacity(0.2))

                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(value / 100), height: 10)
                    .cornerRadius(5)
                    .foregroundColor(color)
            }
        }
        .frame(height: 10)
    }
}

struct ProgressSection: View {
    var title: String
    var value: Int
    var total: Int
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            HStack {
                Text("\(value) / \(total)")
                    .font(.headline)
                Spacer()
                Text(String(format: "%.0f%%", (Double(value) / Double(total)) * 100))
                    .font(.subheadline)
                    .foregroundColor(color)
            }
            .padding(.vertical, 5)

            ProgressBar(value: (Double(value) / Double(total)) * 100, color: color)
        }
        .padding(.vertical, 10)
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(taskViewModel: TaskViewModel(), pomodoroViewModel: PomodoroViewModel())
            .preferredColorScheme(.light)
    }
}

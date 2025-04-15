import SwiftUI
import Charts

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
            VStack(alignment: .leading, spacing: 25) {
                Group {
                    Text("📊 Task Analytics")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    HStack(spacing: 15) {
                        AnalyticsCard(title: "Completed", value: completedTasks, total: totalTasks, percentage: completedPercentage, color: .green)
                        AnalyticsCard(title: "Incomplete", value: incompleteTasks, total: totalTasks, percentage: incompletePercentage, color: .red)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 20) {
                        ProgressSection(title: "Completed Tasks", value: completedTasks, total: totalTasks, color: .green)
                        ProgressSection(title: "Incomplete Tasks", value: incompleteTasks, total: totalTasks, color: .red)
                    }
                    .padding(.horizontal)
                }

                Divider().padding(.horizontal)

                Group {
                    Text("⏱ Study Analytics")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    Picker("Analytics Period", selection: $pomodoroViewModel.selectedPeriod) {
                        ForEach(AnalyticsPeriod.allCases) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: pomodoroViewModel.selectedPeriod) { _ in
                        pomodoroViewModel.fetchSessions()
                    }

                    HStack(spacing: 15) {
                        AnalyticsCard(title: "Pomodoro Sessions", value: pomodoroViewModel.pomodoroCount, color: .blue)
                        AnalyticsCard(title: "Break Sessions", value: pomodoroViewModel.breakCount, color: .purple)
                    }
                    .frame(height: 120)
                    .padding(.horizontal)


                    Text("Pomodoros per Day")
                        .font(.headline)
                        .padding(.horizontal)

                    if pomodoroViewModel.sortedPomodoroData.isEmpty {
                        Text("No data available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Chart {
                            ForEach(pomodoroViewModel.sortedPomodoroData, id: \.0) { (day, count) in
                                BarMark(
                                    x: .value("Day", day),
                                    y: .value("Pomodoros", count)
                                )
                                .foregroundStyle(Color.blue)
                            }
                        }
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Analytics")

    }
}

struct AnalyticsCard: View {
    var title: String
    var value: Int
    var total: Int? = nil
    var percentage: Double? = nil
    var color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            if let total = total, let percentage = percentage {
                Text("\(value) / \(total)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                ProgressBar(value: percentage, color: color)
                    .frame(height: 10)
            } else {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
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

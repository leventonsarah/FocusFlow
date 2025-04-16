import SwiftUI
import Firebase

struct PomodoroTimerView: View {
//    @State private var timeRemaining = 25 * 60
    @State private var timeRemaining = 10 // just to showcase
    @State private var isRunning = false
    @State private var isBreakTime = false
    @State private var rotationAngle: Double = 0.0

    @ObservedObject var viewModel = PomodoroViewModel()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

//    var totalDuration: Int {
//        isBreakTime ? 5 * 60 : 25 * 60
//    }

    var totalDuration: Int {
        isBreakTime ? 5 : 10 // 5s break, 10s focus session for testting
    }

    var progress: Double {
        return 1 - (Double(timeRemaining) / Double(totalDuration))
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Pomodoro Timer")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                        .frame(width: 250, height: 250)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 250, height: 250)
                        .animation(.easeInOut(duration: 0.5), value: progress)

                    VStack {
                        Text(isBreakTime ? "Break" : "Focus")
                            .font(.title2.bold())
                            .foregroundColor(isBreakTime ? .green : .blue)

                        Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))
                            .font(.system(size: 48, weight: .medium, design: .monospaced))
                            .foregroundColor(.primary)
                    }
                }

                HStack(spacing: 30) {
                    Button(action: {
                        isRunning.toggle()
                    }) {
                        Text(isRunning ? "Pause" : "Start")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 120)
                            .background(isRunning ? Color.red : Color.green)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }

                    Button(action: {
                        resetTimer()
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(width: 120)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                }

                VStack(alignment: .leading, spacing: 15) {
                    ProgressSection(
                        title: "Daily Goal Progress",
                        value: viewModel.pomodoroCount,
                        total: viewModel.dailyGoal,
                        color: .blue
                    )

                    HStack {
                        Text("Set Goal:")
                            .font(.subheadline)
                        Spacer()
                        Stepper(value: $viewModel.dailyGoal, in: 1...10) {
                            Text("\(viewModel.dailyGoal) sessions")
                        }
                        .frame(width: 200)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .onReceive(timer) { _ in
                guard isRunning else { return }

                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    viewModel.saveSession(duration: totalDuration, isBreak: isBreakTime)
                    toggleBreak()
                }
            }
        }
    }

    func toggleBreak() {
        isBreakTime.toggle()
        timeRemaining = totalDuration
    }

    func resetTimer() {
        isRunning = false
        isBreakTime = false
        timeRemaining = 25 * 60
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
            .preferredColorScheme(.light)
    }
}

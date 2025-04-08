import SwiftUI

struct PomodoroTimerView: View {
    @State private var timeRemaining = 25 * 60
    @State private var isRunning = false
    @State private var rotationAngle: Double = 0
    @State private var reminders: [String] = []
    @State private var newReminder = ""
    @State private var isBreakTime = false
    @State private var pomodoroCount = 0
    @State var isSpinning = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack {
                Text("Pomodoro Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Spacer()

                VStack {
                    Text(isBreakTime ? "Break Time" : "Focus Time")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(isBreakTime ? Color.green : Color.blue)
                    
                    Text("\(timeRemaining / 60) : \(timeRemaining % 60, specifier: "%02d")")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image("tomato")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 6)
                    .rotationEffect(.degrees(isSpinning ? 360 : 0))
                    .animation(isSpinning ? Animation.linear(duration: Double(timeRemaining)).repeatForever(autoreverses: false) : .default, value: isSpinning)

                Spacer()

                // Buttons to start/pause, reset the timer, and skip to the next session (focus > break, break > focus). The start button gets the tomato spinning, and the pause, reset and skip buttons stop the tomato.
                HStack(spacing: 16) {
                    Button(isRunning ? "Pause" : "Start") {
                        isRunning.toggle()
                        isSpinning.toggle()
                    }
                    .buttonStyle(TimerButtonStyle(color: .red))

                    Button("Reset") {
                        resetTimer()
                        isSpinning = false
                    }
                    .buttonStyle(TimerButtonStyle(color: .orange))

                    Button("Skip") {
                        skipCurrentSession()
                        isSpinning = false
                    }
                    .buttonStyle(TimerButtonStyle(color: .blue))
                }
                .padding(.horizontal)
                
                Spacer()

                Divider()

                // This section is for leaving reminders for work that has to be done during or after the session. By leaving a reminder in the timer page, the student will be able to focus on the task at hand even if he remembered that he had something else to do as well.
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reminders")
                        .font(.title2.bold())
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(reminders, id: \.self) { reminder in
                                HStack {
                                    Text("• \(reminder)")
                                    Spacer()
                                    Button {
                                        deleteReminder(reminder)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }

                            HStack {
                                TextField("New reminder...", text: $newReminder)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                Button {
                                    addReminder()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                }
                                .disabled(newReminder.isEmpty)
                            }
                        }
                        .padding(.top, 12)
                    }
                    .frame(height: 200)
                    .padding(.top)
                }
                .padding()
            }
            .padding()
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isRunning = false
                isSpinning = false
                handleTimerFinished()
            }
        }
    }

    func resetTimer() {
        timeRemaining = isBreakTime ? (pomodoroCount % 4 == 0 ? 15 * 60 : 5 * 60) : 25 * 60
        rotationAngle = 0
        isRunning = false
    }

    func skipCurrentSession() {
        isBreakTime.toggle()
        resetTimer()
    }

    func handleTimerFinished() {
        isBreakTime.toggle()
        if !isBreakTime {
            pomodoroCount += 1
        }
        resetTimer()
    }

    func addReminder() {
        reminders.append(newReminder)
        newReminder = ""
    }

    func deleteReminder(_ reminder: String) {
        reminders.removeAll { $0 == reminder }
    }
}

struct TimerButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
            .preferredColorScheme(.light)
    }
}

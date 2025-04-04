import SwiftUI

struct PomodoroTimerView: View {
    @State private var timeRemaining = 25 * 60
    @State private var isRunning = false
    @State private var reminders: [String] = []
    @State private var newReminder = ""
    @State private var isBreakTime = false
    @State private var pomodoroCount = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.paletteCream.ignoresSafeArea()

            VStack(spacing: 20) {
                Text(isBreakTime ? "Break Time" : "Pomodoro Timer")
                    .font(.largeTitle.bold())
                    .foregroundColor(.paletteNavy)
                    .padding(.top, 20)

                Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                    .font(.system(size: 60, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.paletteSoftBlue.opacity(0.2))
                    .cornerRadius(16)
                    .foregroundColor(.paletteNavy)

                HStack(spacing: 20) {
                    Button(isRunning ? "Pause" : "Start") {
                        isRunning.toggle()
                    }
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.paletteVibrantRed)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    Button("Reset") {
                        timeRemaining = isBreakTime ? (pomodoroCount % 4 == 0 ? 15 * 60 : 5 * 60) : 25 * 60
                        isRunning = false
                    }
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.paletteDeepRed)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)

                VStack(alignment: .center, spacing: 10) {
                    Text("Reminders")
                        .font(.title3.bold())
                        .foregroundColor(.paletteNavy)
                        .padding(.top, 10)

                    TextField("Enter a thought...", text: $newReminder)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Add Reminder") {
                        if !newReminder.isEmpty {
                            reminders.append(newReminder)
                            newReminder = ""
                        }
                    }
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.paletteSoftBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                }

                List {
                    ForEach(reminders, id: \ .self) { reminder in
                        Text(reminder)
                            .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        reminders.remove(atOffsets: indexSet)
                    }
                }
                .frame(height: 160)
                .listStyle(.insetGrouped)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if isRunning && timeRemaining == 0 {
                isRunning = false

                if isBreakTime {
                    isBreakTime = false
                    timeRemaining = 25 * 60
                } else {
                    pomodoroCount += 1
                    isBreakTime = true
                    timeRemaining = (pomodoroCount % 4 == 0) ? 15 * 60 : 5 * 60
                }

                isRunning = true
            }
        }
        .navigationTitle("Pomodoro")
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}

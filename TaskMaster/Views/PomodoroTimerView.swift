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
            Color.softBeige.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("tomato")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                Text(isBreakTime ? "Break Time" : "Pomodoro Timer")
                    .font(.largeTitle.bold())
                    .foregroundColor(isBreakTime ? .warmYellow : .tomatoRed)
                    .padding(.top, 20)

                Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                    .font(.system(size: 60, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.lightGray)
                    .cornerRadius(16)
                    .foregroundColor(.deepNavy)

                HStack(spacing: 20) {
                    Button(isRunning ? "Pause" : "Start") {
                        isRunning.toggle()
                    }
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.tomatoRed)
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
                    .background(Color.warmYellow)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    Button("Skip") {
                        skipCurrentSession()
                    }
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.tomatoRed)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)

                VStack(alignment: .center, spacing: 10) {
                    Text("Reminders")
                        .font(.title3.bold())
                        .foregroundColor(.deepNavy)
                        .padding(.top, 10)

                    TextField("Enter a thought...", text: $newReminder)
                        .padding()
                        .background(Color.lightGray)
                        .cornerRadius(8)

                    Button("Add Reminder") {
                        if !newReminder.isEmpty {
                            reminders.append(newReminder)
                            newReminder = ""
                        }
                    }
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.softGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
            
                List {
                    ForEach(reminders, id: \.self) { reminder in
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

    func skipCurrentSession() {
        isRunning = false
        timeRemaining = 25 * 60  // 重置为一个新的工作周期
        isBreakTime = false  // 确保退出休息时间
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}

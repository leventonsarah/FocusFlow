import SwiftUI
import Firebase

struct PomodoroTimerView: View {
    @State private var timeRemaining = 25 * 60
    @State private var isRunning = false
    @State private var rotationAngle: Double = 0
    @State private var newReminder = ""
    @State private var isBreakTime = false

    @ObservedObject var viewModel = PomodoroViewModel()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Pomodoro Timer")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                VStack(spacing: 10) {
                    Text(isBreakTime ? "Break Time" : "Focus Time")
                        .font(.title3.bold())
                        .foregroundColor(isBreakTime ? .green : .blue)
                    
                    Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))
                        .font(.system(size: 50, weight: .medium, design: .monospaced))
                        .foregroundColor(.primary)
                }
                
//                Button("Test Save Session") {
//                    viewModel.saveSession(duration: 1500, isBreak: false)
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
//                
                Image("tomato")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 6)
                    .rotationEffect(.degrees(rotationAngle))
                    .onReceive(timer) { _ in
                        guard isRunning else { return }
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                            rotationAngle += 3
                        } else {
                            viewModel.saveSession(duration: isBreakTime ? 5 * 60 : 25 * 60, isBreak: isBreakTime)
                            toggleBreak()
                        }
                    }
                
                HStack(spacing: 20) {
                    Button(isRunning ? "Pause" : "Start") {
                        isRunning.toggle()
                    }
                    .font(.headline)
                    .padding()
                    .background(isRunning ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    Button("Reset") {
                        resetTimer()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(Capsule())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reminders")
                        .font(.headline)

                    HStack {
                        TextField("Add reminder...", text: $newReminder)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                            viewModel.addReminder(newReminder)
                            newReminder = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }

                    List {
                        ForEach(viewModel.reminders, id: \.self) { reminder in
                            Text("• \(reminder)")
                                .foregroundColor(.secondary)
                        }
                        .onDelete(perform: viewModel.deleteReminder)
                    }
                    .frame(height: 150)
                }

                Spacer()
            }
            .padding()
        }
    }
    
    func toggleBreak() {
        isBreakTime.toggle()
        timeRemaining = isBreakTime ? 5 * 60 : 25 * 60
        rotationAngle = 0
    }
    
    func resetTimer() {
        isRunning = false
        timeRemaining = 25 * 60
        isBreakTime = false
        rotationAngle = 0
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
            .preferredColorScheme(.light)
    }
}

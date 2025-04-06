import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("FocusFlow")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                    .foregroundColor(.tomatoRed)

                Spacer()

                NavigationLink(destination: TaskListView()) {
                    HomeButtonView(title: "Tasks", systemImage: "list.bullet", color: .softGreen)
                }
                
                NavigationLink(destination: PomodoroTimerView()) {
                    HomeButtonView(title: "Pomodoro Timer", systemImage: "clock.fill", color: .tomatoRed)
                }
                
                NavigationLink(destination: CalendarView()) {
                    HomeButtonView(title: "Calendar", systemImage: "calendar", color: .softGreen)
                }
                
                NavigationLink(destination: MotivationView()) {
                    HomeButtonView(title: "Motivation", systemImage: "sparkles", color: .tomatoRed)
                }
                                
                Spacer()
            }
            .padding()
            .background(Color.softBeige.ignoresSafeArea())
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

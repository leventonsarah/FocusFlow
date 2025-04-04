import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("FocusFlow")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                    .foregroundColor(.paletteNavy)

                Spacer()

                NavigationLink(destination: TaskListView()) {
                    HomeButtonView(title: "Tasks", systemImage: "list.bullet", color: .paletteSoftBlue)
                }
                
                NavigationLink(destination: PomodoroTimerView()) {
                    HomeButtonView(title: "Pomodoro Timer", systemImage: "clock.fill", color: .paletteVibrantRed)
                }
                
                NavigationLink(destination: CalendarView()) {
                    HomeButtonView(title: "Calendar", systemImage: "calendar", color: .paletteDeepRed)
                }
                                
                Spacer()
            }
            .padding()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

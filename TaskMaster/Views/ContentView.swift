import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                Text("FocusFlow")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                    .foregroundColor(.primary)
                
                Spacer()
                
                VStack(spacing: 16) {
                    NavigationLink(destination: TaskListView()) {
                        HomeButtonView(title: "Tasks", systemImage: "checkmark.circle")
                    }
                    
                    NavigationLink(destination: PomodoroTimerView()) {
                        HomeButtonView(title: "Pomodoro Timer", systemImage: "timer")
                    }
                    
                    NavigationLink(destination: CalendarView()) {
                        HomeButtonView(title: "Calendar", systemImage: "calendar")
                    }
                    
                    NavigationLink(destination: MotivationView()) {
                        HomeButtonView(title: "Motivation", systemImage: "sparkles")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light) 
    }
}

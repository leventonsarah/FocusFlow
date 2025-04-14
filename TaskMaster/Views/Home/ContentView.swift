import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isUserLoggedIn = false

    var body: some View {
        Group {
            if isUserLoggedIn {
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
                            
                            NavigationLink(destination: AnalyticsView(taskViewModel: TaskViewModel(), pomodoroViewModel: PomodoroViewModel())) {
                                HomeButtonView(title: "Analytics", systemImage: "chart.bar.xaxis")
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Log Out") {
                                do {
                                    try Auth.auth().signOut()
                                    isUserLoggedIn = false
                                } catch {
                                    print("Error signing out: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            } else {
                LoginView(isUserLoggedIn: $isUserLoggedIn)
                    .padding()
                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
            }
        }
        .onAppear {
            checkUserLoginStatus()
        }
    }

    func checkUserLoginStatus() {
        isUserLoggedIn = Auth.auth().currentUser != nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}


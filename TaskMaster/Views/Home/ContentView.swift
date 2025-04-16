import SwiftUI
import FirebaseAuth

<<<<<<< HEAD
enum LaunchState {
    case splash, login, home
}

struct ContentView: View {
    @State private var launchState: LaunchState = .splash
    @State private var isUserLoggedIn: Bool = false
    @State private var isSplashFinished: Bool = false

    var body: some View {
        Group {
            if !isSplashFinished {
                SplashScreen(isSplashFinished: $isSplashFinished)
            } else {
                switch launchState {
                case .splash:
                    EmptyView()

                case .login:
                    LoginView(isUserLoggedIn: $isUserLoggedIn)
                        .onChange(of: isUserLoggedIn) { newValue in
                            if newValue {
                                launchState = .home
                            }
                        }
                        .padding()
                        .background(Color(.systemGroupedBackground).ignoresSafeArea())

                case .home:
                    HomeScreen(isUserLoggedIn: $isUserLoggedIn)
                }
            }
        }
        .onChange(of: isSplashFinished) { finished in
            if finished {
                checkUserLoginStatus()
            }
        }
    }

    func checkUserLoginStatus() {
        if Auth.auth().currentUser != nil {
            isUserLoggedIn = true
            launchState = .home
        } else {
            isUserLoggedIn = false
            launchState = .login
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//struct ContentView: View {
//    @State private var isUserLoggedIn = false
//
//    var body: some View {
//        Group {
//            if isUserLoggedIn {
//                NavigationView {
//                    VStack(spacing: 24) {
//                        Text("FocusFlow")
//                            .font(.system(size: 32, weight: .heavy, design: .rounded))
//                            .foregroundColor(.primary)
//                        
//                        Spacer()
//                        
//                        VStack(spacing: 16) {
//                            NavigationLink(destination: TaskListView()) {
//                                HomeButtonView(title: "To-Do List", systemImage: "checkmark.circle")
//                            }
//                            
//                            NavigationLink(destination: PomodoroTimerView()) {
//                                HomeButtonView(title: "Pomodoro Timer", systemImage: "timer")
//                            }
//                            
//                            NavigationLink(destination: CalendarView()) {
//                                HomeButtonView(title: "Calendar", systemImage: "calendar")
//                            }
//                            
//                            NavigationLink(destination: MotivationView()) {
//                                HomeButtonView(title: "Motivation", systemImage: "sparkles")
//                            }
//                            
//                            NavigationLink(destination: AnalyticsView(taskViewModel: TaskViewModel(), pomodoroViewModel: PomodoroViewModel())) {
//                                HomeButtonView(title: "Analytics", systemImage: "chart.bar.xaxis")
//                            }
//                        }
//                        .padding(.horizontal)
//                        
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Button(action: {
//                                do {
//                                    try Auth.auth().signOut()
//                                    isUserLoggedIn = false
//                                } catch {
//                                    print("Error signing out: \(error.localizedDescription)")
//                                }
//                            }) {
//                                Label("Log Out", systemImage: "arrow.right.square")
//                                    .font(.subheadline.bold())
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 6)
//                                    .background(Color.red.opacity(0.1))
//                                    .foregroundColor(.red)
//                                    .clipShape(Capsule())
//                            }
//                        }
//                    }
//                }
//            } else {
//                LoginView(isUserLoggedIn: $isUserLoggedIn)
//                    .padding()
//                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
//            }
//        }
//        .onAppear {
//            checkUserLoginStatus()
//        }
//    }
//
//    func checkUserLoginStatus() {
//        isUserLoggedIn = Auth.auth().currentUser != nil
//    }
//}

//struct ContentView: View {
//    @State private var isUserLoggedIn = false
//    
//    @StateObject private var countdownViewModel = CountdownViewModel()
//
//    var body: some View {
//        
//        Group {
//            if isUserLoggedIn {
//                NavigationView {
//                    VStack(spacing: 24) {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("FocusFlow")
//                                .font(.system(size: 32, weight: .heavy, design: .rounded))
//                                .foregroundColor(.primary)
//
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top, 40)
//                        .padding(.horizontal)
//
//                        Spacer()
//
//                        VStack(spacing: 16) {
//                            
//                            NavigationLink(destination: CountdownListView()) {
//                                    HomeButtonView(title: "Countdowns", systemImage: "hourglass")
//                                }
//                            
//                            NavigationLink(destination: TaskListView()) {
//                                HomeButtonView(title: "To-Do List", systemImage: "checkmark.circle")
//                            }
//                            
//                            NavigationLink(destination: PomodoroTimerView()) {
//                                HomeButtonView(title: "Pomodoro Timer", systemImage: "timer")
//                            }
//                            
//                            NavigationLink(destination: CalendarView()) {
//                                HomeButtonView(title: "Calendar", systemImage: "calendar")
//                            }
//                            
//                            NavigationLink(destination: MotivationView()) {
//                                HomeButtonView(title: "Motivation", systemImage: "sparkles")
//                            }
//                            
//                            NavigationLink(destination: AnalyticsView(taskViewModel: TaskViewModel(), pomodoroViewModel: PomodoroViewModel())) {
//                                HomeButtonView(title: "Analytics", systemImage: "chart.bar.xaxis")
//                            }
//                        }
//                        .padding(.horizontal)
//                        
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            if let next = countdownViewModel.upcomingHomeEvent {
//                                HStack {
//                                    Image(systemName: "calendar.badge.clock")
//                                        .foregroundColor(.blue)
//                                    VStack(alignment: .leading, spacing: 2) {
//                                        Text(next.title)
//                                            .font(.subheadline.bold())
//                                        Text("D-\(daysLeft(until: next.date))")
//                                            .font(.caption)
//                                            .foregroundColor(.secondary)
//                                    }
//                                }
//                                .padding(8)
//                                .background(Color.blue.opacity(0.1))
//                                .cornerRadius(12)
//                            }
//                            
//                        }
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Button(action: {
//                                do {
//                                    try Auth.auth().signOut()
//                                    isUserLoggedIn = false
//                                } catch {
//                                    print("Error signing out: \(error.localizedDescription)")
//                                }
//                            }) {
//                                Label("Log Out", systemImage: "arrow.right.square")
//                                    .font(.subheadline.bold())
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 6)
//                                    .background(Color.red.opacity(0.1))
//                                    .foregroundColor(.red)
//                                    .clipShape(Capsule())
//                            }
//                        }
//                    }
//                }
//                .environmentObject(countdownViewModel)
//            } else {
//                LoginView(isUserLoggedIn: $isUserLoggedIn)
//                    .padding()
//                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
//            }
//        }
//        .onAppear {
//            checkUserLoginStatus()
//        }
//    }
//
//    func checkUserLoginStatus() {
//        isUserLoggedIn = Auth.auth().currentUser != nil
//    }
//
//    func daysLeft(until date: Date) -> Int {
//        let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
//        return components.day ?? 0
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .preferredColorScheme(.light)
//    }
//}
//
=======
struct ContentView: View {
    @State private var isUserLoggedIn = false
    @StateObject private var countdownViewModel = CountdownViewModel()
>>>>>>> f5522a3d769b1e41cd7adcd7f46b569822bbe790



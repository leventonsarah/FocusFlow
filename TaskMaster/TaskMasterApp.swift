import SwiftUI
import Firebase
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notifications permission granted.")
            } else {
                print("Notifications permission denied. Error: \(String(describing: error))")
            }
        }

        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

@main
struct TaskMasterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                ContentView()
            } else {
                LoginView(isUserLoggedIn: $isUserLoggedIn)
            }
        }
    }
}

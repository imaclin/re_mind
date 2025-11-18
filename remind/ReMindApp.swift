import SwiftUI
import UserNotifications

@main
struct ReMindApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Set notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ NOTIFICATION PERMISSION GRANTED")
            } else if let error = error {
                print("❌ NOTIFICATION PERMISSION ERROR: \(error.localizedDescription)")
            } else {
                print("❌ NOTIFICATION PERMISSION DENIED")
            }
        }
        
        // Check current notification settings
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📱 NOTIFICATION SETTINGS:")
            print("   Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("   Alert Setting: \(settings.alertSetting.rawValue)")
            print("   Sound Setting: \(settings.soundSetting.rawValue)")
            print("   Badge Setting: \(settings.badgeSetting.rawValue)")
        }
        
        return true
    }
    
    // Handle notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("🔔 NOTIFICATION WILL PRESENT (FOREGROUND)")
        print("   Title: \(notification.request.content.title)")
        print("   Body: \(notification.request.content.body)")
        
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("🔔 NOTIFICATION TAPPED")
        print("   Body: \(response.notification.request.content.body)")
        completionHandler()
    }
}

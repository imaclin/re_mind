import Foundation
import SwiftUI
import UserNotifications
import Combine

class TimerManager: ObservableObject {
    @Published var timers: [TimerData] = [] {
        didSet { saveTimers() }
    }
    @Published var use24HourFormat: Bool = false {
        didSet { saveSettings() }
    }
    @Published var useStrictMode: Bool = false {  // false = loose (±15 min), true = strict (exact time)
        didSet { saveSettings() }
    }
    @Published var backgroundColor: Color = Color(red: 0x99/255.0, green: 0x24/255.0, blue: 0x4F/255.0) {
        didSet { saveBackgroundColor() }
    }
    @Published var textColor: Color = .white {
        didSet { saveTextColor() }
    }
    @Published var backgroundImage: UIImage? = nil {
        didSet { saveBackgroundImage() }
    }
    
    private let timersKey = "savedTimers"
    private let use24HourKey = "use24HourFormat"
    private let strictModeKey = "useStrictMode"
    private let backgroundColorKey = "backgroundColor"
    private let textColorKey = "textColor"
    private let backgroundImageKey = "backgroundImage"
    
    init() {
        // Load saved settings first (before setting up observers)
        self.use24HourFormat = UserDefaults.standard.bool(forKey: use24HourKey)
        self.useStrictMode = UserDefaults.standard.bool(forKey: strictModeKey)
        
        // Load background color
        if let colorData = UserDefaults.standard.array(forKey: backgroundColorKey) as? [Double],
           colorData.count >= 3 {
            self.backgroundColor = Color(red: colorData[0], green: colorData[1], blue: colorData[2])
        }
        
        // Load text color
        if let colorData = UserDefaults.standard.array(forKey: textColorKey) as? [Double],
           colorData.count >= 3 {
            self.textColor = Color(red: colorData[0], green: colorData[1], blue: colorData[2])
        }
        
        // Load background image
        if let imageData = UserDefaults.standard.data(forKey: backgroundImageKey),
           let image = UIImage(data: imageData) {
            self.backgroundImage = image
        }
        
        // Load timers
        if let data = UserDefaults.standard.data(forKey: timersKey),
           let decoded = try? JSONDecoder().decode([TimerData].self, from: data) {
            self.timers = decoded
        }
        
        // If no saved timers, create defaults
        if timers.isEmpty {
            timers = [
                TimerData(targetHour: 8.0, notificationMessage: "Time's up!"),
                TimerData(targetHour: 12.0, notificationMessage: "Break time!"),
                TimerData(targetHour: 17.0, notificationMessage: "End of day!")
            ]
        }
        
        // Schedule all notifications
        timers.forEach { scheduleNotification(for: $0) }
        
        print("📂 LOADED SETTINGS:")
        print("   24-Hour Format: \(use24HourFormat)")
        print("   Strict Mode: \(useStrictMode)")
        print("   Timers Count: \(timers.count)")
    }
    
    // MARK: - Persistence
    
    private func saveTimers() {
        if let encoded = try? JSONEncoder().encode(timers) {
            UserDefaults.standard.set(encoded, forKey: timersKey)
        }
    }
    
    private func loadTimers() {
        if let data = UserDefaults.standard.data(forKey: timersKey),
           let decoded = try? JSONDecoder().decode([TimerData].self, from: data) {
            timers = decoded
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(use24HourFormat, forKey: use24HourKey)
        UserDefaults.standard.set(useStrictMode, forKey: strictModeKey)
    }
    
    private func loadSettings() {
        use24HourFormat = UserDefaults.standard.bool(forKey: use24HourKey)
        useStrictMode = UserDefaults.standard.bool(forKey: strictModeKey)
    }
    
    private func saveBackgroundColor() {
        let uiColor = UIColor(backgroundColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        UserDefaults.standard.set([Double(red), Double(green), Double(blue)], forKey: backgroundColorKey)
    }
    
    private func loadBackgroundColor() {
        if let colorData = UserDefaults.standard.array(forKey: backgroundColorKey) as? [Double],
           colorData.count >= 3 {
            backgroundColor = Color(red: colorData[0], green: colorData[1], blue: colorData[2])
        }
    }
    
    private func saveTextColor() {
        let uiColor = UIColor(textColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        UserDefaults.standard.set([Double(red), Double(green), Double(blue)], forKey: textColorKey)
    }
    
    private func loadTextColor() {
        if let colorData = UserDefaults.standard.array(forKey: textColorKey) as? [Double],
           colorData.count >= 3 {
            textColor = Color(red: colorData[0], green: colorData[1], blue: colorData[2])
        }
    }
    
    private func saveBackgroundImage() {
        if let image = backgroundImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: backgroundImageKey)
        } else {
            UserDefaults.standard.removeObject(forKey: backgroundImageKey)
        }
    }
    
    private func loadBackgroundImage() {
        if let imageData = UserDefaults.standard.data(forKey: backgroundImageKey),
           let image = UIImage(data: imageData) {
            backgroundImage = image
        }
    }
    
    func updateTime(id: UUID, targetHour: Double) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        
        print("⏰ UPDATING TIMER TIME")
        print("   Timer ID: \(id.uuidString)")
        print("   New Target Hour: \(targetHour)")
        
        timers[index].targetHour = targetHour
        
        // Cancel old notification first
        cancelNotification(for: id)
        
        // Wait a moment to ensure cancellation completes, then reschedule
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scheduleNotification(for: self.timers[index])
        }
    }
    
    func updateMessage(id: UUID, message: String) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        
        timers[index].notificationMessage = message
        
        // Cancel and reschedule with new message
        cancelNotification(for: id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scheduleNotification(for: self.timers[index])
        }
    }
    
    func updateSound(id: UUID, sound: String) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        
        timers[index].notificationSound = sound
        
        // Cancel and reschedule with new sound
        cancelNotification(for: id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scheduleNotification(for: self.timers[index])
        }
    }
    
    func updateStrictMode(id: UUID, isStrict: Bool) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        
        print("⚙️ UPDATING STRICT MODE")
        print("   Timer ID: \(id.uuidString)")
        print("   New Mode: \(isStrict ? "STRICT" : "LOOSE")")
        
        timers[index].isStrict = isStrict
        
        // Cancel and reschedule with new mode
        cancelNotification(for: id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scheduleNotification(for: self.timers[index])
        }
    }
    
    func addTimer() {
        let newTimer = TimerData(
            targetHour: 12.0,
            notificationMessage: "New reminder!"
        )
        print("➕ ADDING NEW TIMER")
        print("   Timer ID: \(newTimer.id.uuidString)")
        timers.append(newTimer)
        scheduleNotification(for: newTimer)
    }
    
    func deleteTimer(id: UUID) {
        print("🗑️ DELETING TIMER")
        print("   Timer ID: \(id.uuidString)")
        cancelNotification(for: id)
        timers.removeAll { $0.id == id }
    }
    
    private func scheduleNotification(for timer: TimerData) {
        let content = UNMutableNotificationContent()
        content.title = ""  // Empty title to hide app name
        content.body = timer.notificationMessage
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: timer.notificationSound))
        
        // Add randomness only if in loose mode: ±15 minutes (±900 seconds)
        let randomOffset = timer.isStrict ? 0.0 : Double.random(in: -900...900)
        let targetTimeInSeconds = timer.targetHour * 3600 + randomOffset
        
        // Convert to hours and minutes
        let totalMinutes = Int(targetTimeInSeconds / 60)
        let hour = (totalMinutes / 60) % 24
        let minute = totalMinutes % 60
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: timer.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        // Debug logging
        print("🔔 SCHEDULING NOTIFICATION")
        print("   Timer ID: \(timer.id.uuidString)")
        print("   Target Hour: \(timer.targetHour) (\(formatDebugTime(timer.targetHour)))")
        print("   Mode: \(timer.isStrict ? "STRICT" : "LOOSE")")
        if !timer.isStrict {
            print("   Random Offset: \(Int(randomOffset/60)) minutes")
        }
        print("   Scheduled Time: \(hour):\(String(format: "%02d", minute))")
        print("   Message: \(timer.notificationMessage)")
        print("   Repeats: Daily")
        print("   Next Fire: \(getNextFireDate(hour: hour, minute: minute) ?? "Unknown")")
        print("---")
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ ERROR scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled successfully for \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
    
    private func formatDebugTime(_ hour: Double) -> String {
        let h = Int(hour)
        let m = Int((hour.truncatingRemainder(dividingBy: 1)) * 60)
        let period = h >= 12 ? "PM" : "AM"
        let displayHour = h == 0 ? 12 : (h > 12 ? h - 12 : h)
        return String(format: "%d:%02d %@", displayHour, m, period)
    }
    
    private func getNextFireDate(hour: Int, minute: Int) -> String? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let now = Date()
        if let nextDate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: nextDate)
        }
        return nil
    }
    
    private func cancelNotification(for id: UUID) {
        print("🚫 CANCELING NOTIFICATION")
        print("   Timer ID: \(id.uuidString)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [id.uuidString]
        )
        
        // Verify cancellation
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let stillExists = requests.contains { $0.identifier == id.uuidString }
            if stillExists {
                print("   ⚠️ WARNING: Notification still exists after cancel!")
            } else {
                print("   ✅ Notification successfully removed")
            }
        }
    }
    
    // Debug function to check all pending notifications
    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 PENDING NOTIFICATIONS: \(requests.count)")
            print("   Expected: \(self.timers.count)")
            
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nextTriggerDate = trigger.nextTriggerDate() {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .short
                    print("   - ID: \(request.identifier)")
                    print("     Message: \(request.content.body)")
                    print("     Next: \(formatter.string(from: nextTriggerDate))")
                    let dateComponents = trigger.dateComponents
                    let hour = dateComponents.hour ?? 0
                    let minute = dateComponents.minute ?? 0
                    print("     Time: \(hour):\(String(format: "%02d", minute))")
                }
            }
            if requests.isEmpty {
                print("   ⚠️ NO PENDING NOTIFICATIONS!")
            }
            
            // Check for orphaned notifications
            let timerIDs = Set(self.timers.map { $0.id.uuidString })
            let notificationIDs = Set(requests.map { $0.identifier })
            let orphaned = notificationIDs.subtracting(timerIDs)
            if !orphaned.isEmpty {
                print("   ⚠️ ORPHANED NOTIFICATIONS: \(orphaned.count)")
                for id in orphaned {
                    print("     - \(id)")
                }
            }
        }
    }
    
    // Clear all pending notifications
    func clearAllNotifications() {
        print("🗑️ CLEARING ALL NOTIFICATIONS")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Verify
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("   Remaining: \(requests.count)")
                if requests.isEmpty {
                    print("   ✅ All notifications cleared")
                } else {
                    print("   ⚠️ Some notifications still remain!")
                }
            }
        }
    }
    
    // Reschedule all notifications (useful after clearing)
    func rescheduleAllNotifications() {
        print("🔄 RESCHEDULING ALL NOTIFICATIONS")
        clearAllNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.timers.forEach { timer in
                self.scheduleNotification(for: timer)
            }
            print("   ✅ Rescheduled \(self.timers.count) notifications")
        }
    }
}

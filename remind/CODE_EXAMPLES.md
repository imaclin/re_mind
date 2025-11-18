# ReMind - Code Examples & Snippets

## 🎨 Liquid Glass Effect Usage

### Basic Application
```swift
VStack {
    Text("Hello")
    Text("World")
}
.liquidGlass(color: .blue)  // Apply liquid glass effect
```

### Custom Colors
```swift
// Blue glass
myView.liquidGlass(color: .blue)

// Purple glass
myView.liquidGlass(color: .purple)

// Custom color
myView.liquidGlass(color: Color(red: 0.3, green: 0.5, blue: 0.8))
```

## ⏱️ Timer Operations

### Creating Custom Timer
```swift
let customTimer = TimerData(
    title: "Meditation",
    duration: 600,  // 10 minutes in seconds
    notificationSound: "chime.caf",
    notificationMessage: "Time to reflect"
)
```

### Managing Timer State
```swift
let manager = TimerManager()

// Start timer
manager.startTimer(id: timer.id)

// Pause timer
manager.pauseTimer(id: timer.id)

// Reset to original duration
manager.resetTimer(id: timer.id)

// Update duration (in seconds)
manager.updateTimerDuration(id: timer.id, duration: 1800)
```

### Updating Timer Settings
```swift
manager.updateTimerSettings(
    id: timer.id,
    title: "Pomodoro Work",
    message: "Great work! Take a 5-minute break.",
    sound: "bell.caf"
)
```

## 🎭 Custom Views

### Creating a Timer Card
```swift
struct MyTimerCard: View {
    @ObservedObject var manager: TimerManager
    let timer: TimerData
    
    var body: some View {
        VStack {
            Text(timer.title)
            Text(formatTime(timer.remainingTime))
            
            Button("Start") {
                manager.startTimer(id: timer.id)
            }
        }
        .liquidGlass(color: .blue)
    }
}
```

### Time Formatting Helper
```swift
func formatTime(_ timeInterval: TimeInterval) -> String {
    let hours = Int(timeInterval) / 3600
    let minutes = (Int(timeInterval) % 3600) / 60
    let seconds = Int(timeInterval) % 60
    
    if hours > 0 {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    } else {
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
```

## 🔔 Notification Handling

### Scheduling a Notification
```swift
let content = UNMutableNotificationContent()
content.title = "Timer Complete"
content.body = "Your timer has finished!"
content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "chime.caf"))

let trigger = UNTimeIntervalNotificationTrigger(
    timeInterval: 300,  // 5 minutes
    repeats: false
)

let request = UNNotificationRequest(
    identifier: UUID().uuidString,
    content: content,
    trigger: trigger
)

UNUserNotificationCenter.current().add(request)
```

### Canceling Notifications
```swift
let identifier = "my-timer-id"
UNUserNotificationCenter.current().removePendingNotificationRequests(
    withIdentifiers: [identifier]
)
```

## 🎨 Custom Liquid Glass Modifier

### Creating Your Own Glass Effect
```swift
struct MyGlassModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .background(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.3), radius: 20)
    }
}

extension View {
    func myGlass(color: Color) -> some View {
        modifier(MyGlassModifier(color: color))
    }
}
```

## 📊 Progress Ring

### Custom Progress Indicator
```swift
struct ProgressRing: View {
    let progress: Double  // 0.0 to 1.0
    let color: Color
    
    var body: some View {
        ZStack {
            // Background
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 8)
            
            // Progress
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
        .frame(width: 120, height: 120)
    }
}

// Usage
ProgressRing(
    progress: timer.remainingTime / timer.duration,
    color: .blue
)
```

## 🎬 Animations

### Rotating Gradient Animation
```swift
struct AnimatedGradient: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        RadialGradient(
            colors: [.blue.opacity(0.3), .clear],
            center: .center,
            startRadius: 0,
            endRadius: 200
        )
        .blur(radius: 6)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(
                .easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
            ) {
                rotation = 180
            }
        }
    }
}
```

### Smooth Scale Animation
```swift
@State private var scale: CGFloat = 1.0

var body: some View {
    myView
        .scaleEffect(scale)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
            ) {
                scale = 1.15
            }
        }
}
```

## 🎯 SwiftUI Best Practices

### Observed Object vs StateObject
```swift
// In parent view (owns the data)
@StateObject private var manager = TimerManager()

// In child view (receives the data)
@ObservedObject var manager: TimerManager
```

### Environment Values
```swift
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Close") {
            dismiss()
        }
    }
}
```

### Conditional View Rendering
```swift
var body: some View {
    VStack {
        if timer.isRunning {
            PauseButton()
        } else {
            PlayButton()
        }
    }
}
```

## 📱 Sheet Presentation

### Modal Sheet
```swift
struct ParentView: View {
    @State private var showSettings = false
    
    var body: some View {
        Button("Settings") {
            showSettings = true
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}
```

### Full Screen Cover
```swift
.fullScreenCover(isPresented: $showFullScreen) {
    MyFullScreenView()
}
```

## 🎨 Gradient Backgrounds

### Multi-Color Linear Gradient
```swift
LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.1, green: 0.1, blue: 0.2),
        Color(red: 0.15, green: 0.05, blue: 0.25),
        Color(red: 0.2, green: 0.1, blue: 0.3)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Radial Gradient with Opacity
```swift
RadialGradient(
    gradient: Gradient(colors: [
        Color.blue.opacity(0.3),
        Color.clear
    ]),
    center: .center,
    startRadius: 0,
    endRadius: 200
)
.blur(radius: 60)
```

## 🔧 Combine Publishers

### Timer Publisher
```swift
import Combine

let cancellable = Timer.publish(every: 0.1, on: .main, in: .common)
    .autoconnect()
    .sink { _ in
        updateTimer()
    }

// Don't forget to cancel
cancellable.cancel()
```

### Managing Multiple Subscriptions
```swift
private var cancellables: [UUID: AnyCancellable] = [:]

// Add subscription
cancellables[id] = timerPublisher.sink { _ in
    // Handle update
}

// Remove subscription
cancellables[id]?.cancel()
cancellables.removeValue(forKey: id)
```

## 🎯 Common Patterns

### Format Duration from Picker Values
```swift
func durationFromPicker(hours: Int, minutes: Int, seconds: Int) -> TimeInterval {
    TimeInterval(hours * 3600 + minutes * 60 + seconds)
}

// Usage
let duration = durationFromPicker(hours: 1, minutes: 30, seconds: 0)
// Returns: 5400.0 seconds
```

### Extract Hours/Minutes/Seconds
```swift
func componentsFrom(duration: TimeInterval) -> (hours: Int, minutes: Int, seconds: Int) {
    let totalSeconds = Int(duration)
    return (
        hours: totalSeconds / 3600,
        minutes: (totalSeconds % 3600) / 60,
        seconds: totalSeconds % 60
    )
}

// Usage
let (h, m, s) = componentsFrom(duration: 5400)
// h = 1, m = 30, s = 0
```

## 🎨 Color Extensions

### Custom Colors
```swift
extension Color {
    static let timerBlue = Color(red: 0.231, green: 0.510, blue: 0.965)
    static let timerPurple = Color(red: 0.659, green: 0.333, blue: 0.969)
    static let timerPink = Color(red: 0.925, green: 0.282, blue: 0.600)
}

// Usage
myView.liquidGlass(color: .timerBlue)
```

## 📝 Documentation Comments

### Documenting Functions
```swift
/// Formats a time interval into a human-readable string
/// - Parameter timeInterval: The time in seconds
/// - Returns: Formatted string in "HH:MM:SS" or "MM:SS" format
func formatTime(_ timeInterval: TimeInterval) -> String {
    // Implementation
}
```

### Documenting Types
```swift
/// Represents a single timer with customizable duration and notifications
struct TimerData: Identifiable {
    /// Unique identifier for the timer
    let id: UUID
    
    /// Display name shown to the user
    var title: String
}
```

---

## 💡 Tips & Tricks

1. **Performance**: Use `.id()` modifier to force view recreation when needed
2. **Debugging**: Add `.border(Color.red)` to visualize view bounds
3. **Preview**: Use `#Preview` for quick SwiftUI previews
4. **State**: Keep `@State` private to the view that owns it
5. **Animations**: Use `.animation(_:value:)` for targeted animations

---

**Ready to customize?** Start with these examples and make ReMind your own!

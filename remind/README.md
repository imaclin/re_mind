# ReMind - Beautiful iOS Timer App

A stunning single-page iOS timer app featuring liquid glass design with three customizable timers.

## Features

- 🎨 **Liquid Glass Design** - Beautiful glassmorphism UI with animated refraction effects
- ⏱️ **Three Independent Timers** - Each on its own elegant card
- 🔔 **Custom Notifications** - Personalize notification sounds and messages for each timer
- ⚙️ **Easy Configuration** - Adjust time, notification sound, and message per timer
- 🎭 **Smooth Animations** - Fluid progress rings and background effects

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Setup Instructions

### Option 1: Create Xcode Project (Recommended)

1. Open Xcode
2. Create a new iOS App project:
   - Product Name: `ReMind`
   - Interface: SwiftUI
   - Language: Swift
   - Bundle Identifier: `com.yourname.ReMind`
3. Replace the default files with the provided source files:
   - Copy all `.swift` files maintaining the folder structure
   - Models/
   - ViewModels/
   - Views/
4. Add Info.plist configurations for notifications
5. In Project Settings → Signing & Capabilities:
   - Add "Push Notifications" capability
   - Add "Background Modes" and enable "Audio, AirPlay, and Picture in Picture"

### Option 2: Swift Package Manager

You can also create this as a Swift Package and run it via Xcode.

## Project Structure

```
ReMind/
├── ReMindApp.swift           # App entry point with notification setup
├── ContentView.swift          # Main view with gradient background
├── Models/
│   └── TimerModel.swift      # Timer data models and notification sounds
├── ViewModels/
│   └── TimerManager.swift    # Timer state management and business logic
└── Views/
    ├── LiquidGlassModifier.swift    # Custom liquid glass effect modifier
    ├── TimerCardView.swift          # Individual timer card component
    └── TimerSettingsView.swift      # Settings sheet for each timer
```

## Usage

1. **Start a Timer**: Tap the "Start" button on any timer card
2. **Pause/Resume**: Use the Pause button while timer is running
3. **Reset**: Return timer to its original duration
4. **Configure**: Tap the gear icon to:
   - Change timer name
   - Set duration (hours, minutes, seconds)
   - Customize notification message
   - Select notification sound

## Design Details

The app implements a liquid glass effect inspired by WebGL shader properties:
- **Refractive Index**: 1.33 (eta: 0.752)
- **Backdrop Blur**: 3px with saturation and contrast adjustments
- **Animated Gradient**: Rotating and scaling refraction layer
- **Multi-layer Shadows**: Depth and glow effects

Each timer card features:
- Glassmorphic card with backdrop blur
- Animated circular progress indicator
- Smooth color transitions (blue, purple, pink)
- Elegant typography with SF Rounded

## Notifications

The app requests notification permissions on launch. Ensure notifications are enabled in iOS Settings for the best experience.

## Customization

- **Colors**: Modify `cardColor` in `TimerCardView.swift`
- **Sounds**: Add more notification sounds in `NotificationSound` enum
- **Duration Limits**: Adjust picker ranges in `TimerSettingsView.swift`
- **Glass Effect**: Tweak blur, opacity in `LiquidGlassModifier.swift`

## License

Free to use and modify for personal projects.

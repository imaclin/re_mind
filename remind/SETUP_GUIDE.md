# ReMind Setup Guide

## Quick Start (5 minutes)

### Creating the Xcode Project

1. **Open Xcode** (version 15.0 or later)

2. **Create New Project**
   - Select `File` → `New` → `Project`
   - Choose `iOS` → `App`
   - Click `Next`

3. **Configure Project**
   - **Product Name**: `ReMind`
   - **Team**: Select your team (or leave as None for simulator testing)
   - **Organization Identifier**: `com.yourname` (or your preferred identifier)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None
   - Uncheck "Include Tests" (optional)
   - Click `Next`

4. **Choose Location**
   - Select the parent folder of this repository
   - Ensure "Create Git repository" is unchecked (already exists)
   - Click `Create`

5. **Replace Default Files**
   - Delete the default `ContentView.swift` and `ReMindApp.swift` created by Xcode
   - In Xcode's Project Navigator, right-click on the `ReMind` folder
   - Select `Add Files to "ReMind"...`
   - Add all the source files from this repository:
     - `ReMindApp.swift`
     - `ContentView.swift`
     - `Models/` folder
     - `ViewModels/` folder
     - `Views/` folder

6. **Configure Capabilities**
   - Select the project in Project Navigator
   - Select the `ReMind` target
   - Go to `Signing & Capabilities` tab
   - Click `+ Capability` and add:
     - **Push Notifications**
     - **Background Modes** → Check "Audio, AirPlay, and Picture in Picture"

7. **Build and Run**
   - Select your target device (iPhone simulator or physical device)
   - Press `Cmd + R` or click the Play button
   - Grant notification permissions when prompted

## File Structure in Xcode

After adding files, your project should look like this:

```
ReMind (Project)
├── ReMind (Group)
│   ├── ReMindApp.swift
│   ├── ContentView.swift
│   ├── Models
│   │   └── TimerModel.swift
│   ├── ViewModels
│   │   └── TimerManager.swift
│   ├── Views
│   │   ├── LiquidGlassModifier.swift
│   │   ├── TimerCardView.swift
│   │   └── TimerSettingsView.swift
│   └── Assets.xcassets
└── Info.plist
```

## Troubleshooting

### "Cannot find type X in scope"
- Ensure all files are added to the target (check the Target Membership in File Inspector)
- Clean build folder: `Product` → `Clean Build Folder` (Cmd + Shift + K)
- Rebuild: `Product` → `Build` (Cmd + B)

### Notifications not appearing
1. Check notification permissions:
   - Settings → Notifications → ReMind → Allow Notifications
2. Run on a physical device (simulator has limited notification support)
3. Ensure the app is in background when timer completes

### Build errors about missing imports
- Ensure deployment target is iOS 16.0 or later
- Check in Project Settings → General → Minimum Deployments

### Simulator Performance
- Liquid glass effects may run slower on simulator
- Test on a physical device for best performance

## Testing the App

1. **Timer Functionality**
   - Set a short timer (e.g., 10 seconds)
   - Start the timer
   - Watch the progress ring animate
   - Receive notification when complete

2. **Settings**
   - Tap gear icon on any timer
   - Change duration using pickers
   - Modify notification message
   - Select different notification sound
   - Save and test

3. **Visual Effects**
   - Observe the liquid glass cards
   - Note the animated gradient effects
   - Check smooth transitions between states

## Running Without Xcode Project

If you prefer to explore the code without creating a full Xcode project:

```bash
cd re_mind
swift build
```

Note: This won't run the iOS app but will validate the Swift code compiles.

## Next Steps

- Customize colors in `TimerCardView.swift`
- Add more notification sounds in `TimerModel.swift`
- Adjust glass effect intensity in `LiquidGlassModifier.swift`
- Experiment with different background gradients in `ContentView.swift`

## Need Help?

- Check the main [README.md](README.md) for feature details
- Review individual file comments for implementation details
- iOS 16+ SwiftUI documentation: https://developer.apple.com/documentation/swiftui

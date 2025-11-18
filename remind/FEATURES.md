# ReMind Features & Design Details

## 🎨 Visual Design

### Liquid Glass Effect
The app implements a sophisticated glassmorphism design that mimics WebGL shader properties:

- **Backdrop Blur**: 3px blur with 116.5% saturation and 112% contrast
- **Transparency**: RGBA(255, 255, 255, 0.1) base with layered opacity
- **Refraction Layer**: Animated radial gradient that rotates 180° and scales to 115%
- **Border**: 1px white border at 10% opacity with gradient highlights
- **Shadows**: 
  - Outer shadow: 8px blur with 10% black
  - Colored glow: 24px blur with 20% accent color
  - Inner highlight: White gradient stroke on edges

### Animation System
- **8-second ease-in-out** animation cycle for refraction layer
- **Smooth progress rings** with linear interpolation
- **Real-time countdown** updates every 0.1 seconds
- **Fluid state transitions** for play/pause/reset

### Color Scheme
Each timer card has its own accent color:
1. **Timer 1**: Blue (`#3B82F6`)
2. **Timer 2**: Purple (`#A855F7`)
3. **Timer 3**: Pink (`#EC4899`)

Background gradient:
- Top: Dark blue-gray `RGB(26, 26, 51)`
- Middle: Deep purple `RGB(38, 13, 64)`
- Bottom: Rich purple `RGB(51, 26, 77)`

### Typography
- **App Title**: 42pt, Bold, SF Rounded
- **Timer Display**: 56pt, Thin, SF Rounded, Monospaced digits
- **Card Title**: Title 2, Semibold
- **Body Text**: System default with appropriate weights

## ⏱️ Timer Features

### Individual Timer Controls
Each of the 3 timers includes:
- **Start/Pause Button**: Toggle timer state
- **Reset Button**: Return to original duration
- **Settings Button**: Access configuration sheet

### Configurable Settings
Per-timer customization:
- **Name**: Custom label for each timer
- **Duration**: 
  - Hours: 0-23
  - Minutes: 0-59
  - Seconds: 0-59
  - Maximum: ~24 hours
- **Notification Message**: Custom text for alerts
- **Notification Sound**: 24 iOS system sounds to choose from

### Progress Indication
- **Circular Progress Ring**: 120pt diameter
  - Background ring: White at 20% opacity, 8pt stroke
  - Active ring: Gradient color, 8pt stroke with round caps
  - Smooth animations with linear timing
- **Digital Display**: Large monospaced digits showing remaining time
- **Format**: 
  - Under 1 hour: `MM:SS`
  - 1 hour+: `HH:MM:SS`

## 🔔 Notification System

### Sound Options (24 total)
System sounds include:
- Basic: Default, Bell, Chime, Glass, Horn, Note, Ping, Pop, Pulse
- Musical: Anticipate, Bloom, Calypso, Fanfare, Ladder, Minuet, Noir, Sherwood Forest, Spell
- Effects: News Flash, Suspense, Telegraph, Tiptoes, Typewriters, Update

### Notification Behavior
- **Permission Request**: Automatic on app launch
- **Scheduling**: Uses `UNUserNotificationCenter` 
- **Delivery**: Local notifications with custom sounds
- **Cancellation**: Automatic when timer is paused/reset
- **Background**: Works even when app is closed

## 🏗️ Technical Architecture

### MVVM Pattern
- **Models**: `TimerData`, `NotificationSound`
- **ViewModels**: `TimerManager` (ObservableObject)
- **Views**: `ContentView`, `TimerCardView`, `TimerSettingsView`
- **Modifiers**: `LiquidGlassModifier`

### State Management
- `@StateObject` for TimerManager lifecycle
- `@ObservedObject` for timer updates
- `@State` for local view state
- `@Environment` for dismiss actions

### Timer Implementation
- Uses `Combine` framework with `Timer.publish`
- 0.1-second update interval for smooth animations
- Calculates remaining time from end date
- Automatic cleanup on pause/completion

### Performance Optimizations
- **Subscription Management**: Proper cancellation prevents memory leaks
- **Conditional Rendering**: Only active timers have running publishers
- **Efficient Updates**: Targeted view updates with `@Published` properties
- **Blur Optimization**: Strategic use of backdrop filters

## 📱 iOS Integration

### Requirements
- iOS 16.0+ (for enhanced SwiftUI features)
- UserNotifications framework
- Combine framework
- SwiftUI 4.0+

### Permissions
- **Notifications**: Alert, Sound, Badge
- **Background**: Optional for better timer accuracy

### Accessibility
- VoiceOver support through semantic SwiftUI
- Dynamic Type compatibility
- High contrast support via system materials
- Clear visual hierarchy

## 🎯 Use Cases

Perfect for:
- **Pomodoro Technique**: 25-minute work intervals
- **Exercise Routines**: Multiple interval timers
- **Cooking**: Different dishes needing separate timers
- **Meditation**: Customizable session lengths
- **Study Sessions**: Track multiple subjects
- **Tea Brewing**: Perfect steep times

## 🔮 Future Enhancement Ideas

Potential additions:
- Persistent timer state (save between app launches)
- Timer presets/templates
- Timer history and statistics
- Sound volume control
- Haptic feedback options
- Widget support
- Apple Watch companion
- Dark mode variations
- Additional timer slots (4-6 timers)
- Timer groups/categories
- Export/import timer configurations

## 🎨 Design Philosophy

**Minimalist Elegance**: Clean interface with focus on essential features

**Visual Depth**: Multiple layered effects create sense of dimensionality

**Intuitive Interaction**: Familiar controls with discoverable settings

**Performance First**: Smooth 60fps animations even with complex effects

**iOS Native**: Follows Apple Human Interface Guidelines while adding unique personality

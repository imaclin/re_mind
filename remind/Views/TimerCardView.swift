import SwiftUI

struct TimerCardView: View {
    @ObservedObject var manager: TimerManager
    let timer: TimerData
    @State private var localTargetHour: Double
    @State private var localMessage: String
    @State private var localIsStrict: Bool
    @State private var showingTimePicker = false
    
    init(manager: TimerManager, timer: TimerData) {
        self.manager = manager
        self.timer = timer
        _localTargetHour = State(initialValue: timer.targetHour)
        _localMessage = State(initialValue: timer.notificationMessage)
        _localIsStrict = State(initialValue: timer.isStrict)
    }
    
    private var cardColor: Color {
        let colors: [Color] = [.blue, .purple, .pink]
        let index = manager.timers.firstIndex(where: { $0.id == timer.id }) ?? 0
        return colors[index % colors.count]
    }
    
    private var targetDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        let totalMinutes = Int(round(localTargetHour * 60))
        components.hour = totalMinutes / 60
        components.minute = totalMinutes % 60
        return calendar.date(from: components) ?? Date()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Tappable Time Display
            Button(action: { showingTimePicker = true }) {
                HStack(spacing: 4) {
                    if !localIsStrict {
                        Text("~")
                            .font(.system(size: 60, weight: .light, design: .rounded))
                            .foregroundColor(manager.textColor.opacity(0.7))
                    }
                    Text(formatHour(localTargetHour))
                        .font(.system(size: 72, weight: .semibold, design: .rounded))
                        .foregroundColor(manager.textColor)
                        .monospacedDigit()
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 2)
            
            // Notification Message
            VStack(alignment: .leading, spacing: 8) {
                TextField("Enter message...", text: $localMessage)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(manager.textColor.opacity(0.1))
                    .foregroundColor(manager.textColor)
                    .cornerRadius(8)
                    .onChange(of: localMessage) { newValue in
                        manager.updateMessage(id: timer.id, message: newValue)
                    }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
        .liquidGlass(color: cardColor)
        .sheet(isPresented: $showingTimePicker) {
            NavigationView {
                VStack(spacing: 24) {
                    DatePicker(
                        "Select Time",
                        selection: Binding(
                            get: { targetDate },
                            set: { newDate in
                                let calendar = Calendar.current
                                let components = calendar.dateComponents([.hour, .minute], from: newDate)
                                let hour = components.hour ?? 0
                                let minute = components.minute ?? 0
                                // Convert to decimal hours with proper rounding
                                let newTargetHour = Double(hour) + (Double(minute) / 60.0)
                                localTargetHour = newTargetHour
                                manager.updateTime(id: timer.id, targetHour: newTargetHour)
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    
                    Divider()
                    
                    // Strict/Loose Mode Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notification Timing")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Picker("Mode", selection: $localIsStrict.animation(.spring(response: 0.3, dampingFraction: 0.7))) {
                            Text("Loose").tag(false)
                            Text("Exact").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: localIsStrict) { newValue in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                manager.updateStrictMode(id: timer.id, isStrict: newValue)
                            }
                        }
                        
                        Text(localIsStrict ? "Notification at exact time" : "Notification within ±15 minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .animation(.easeInOut(duration: 0.2), value: localIsStrict)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Set Time")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showingTimePicker = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func formatHour(_ hour: Double) -> String {
        // Use same conversion logic as targetDate to ensure consistency
        let totalMinutes = Int(round(hour * 60))
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        
        if manager.use24HourFormat {
            // 24-hour format
            if m == 0 {
                return String(format: "%02d:00", h)
            } else {
                return String(format: "%02d:%02d", h, m)
            }
        } else {
            // 12-hour format with AM/PM
            let period = h >= 12 ? "PM" : "AM"
            let displayHour = h == 0 ? 12 : (h > 12 ? h - 12 : h)
            
            if m == 0 {
                return String(format: "%d:00 %@", displayHour, period)
            } else {
                return String(format: "%d:%02d %@", displayHour, m, period)
            }
        }
    }
}

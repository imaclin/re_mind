import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    @State private var showingInfo = false
    @Namespace private var scrollNamespace
    
    var body: some View {
        ZStack {
            // Background
            if let backgroundImage = timerManager.backgroundImage {
                GeometryReader { geometry in
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .ignoresSafeArea()
            } else {
                timerManager.backgroundColor
                    .ignoresSafeArea()
            }
            
            // Main content
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with title (left) and buttons (right)
                        HStack {
                            // ReMind title in top left
                            Text("ReMind")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(timerManager.textColor)
                            
                            Spacer()
                            
                            // Add button
                            Button(action: { 
                                timerManager.addTimer()
                                // Scroll to new timer after a brief delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    if let lastTimer = timerManager.timers.last {
                                        withAnimation {
                                            proxy.scrollTo(lastTimer.id, anchor: .bottom)
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(timerManager.textColor.opacity(0.9))
                                    .padding(12)
                                    .background(timerManager.textColor.opacity(0.1))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(timerManager.textColor.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            // Info button in top right
                            Button(action: { showingInfo = true }) {
                                Image(systemName: "info.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(timerManager.textColor.opacity(0.9))
                                    .padding(12)
                                    .background(timerManager.textColor.opacity(0.1))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(timerManager.textColor.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        // Timer Cards with swipe to delete
                        ForEach(timerManager.timers) { timer in
                            DeletableTimerCard(manager: timerManager, timer: timer)
                                .id(timer.id)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
                .sheet(isPresented: $showingInfo) {
                    InfoView(manager: timerManager)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

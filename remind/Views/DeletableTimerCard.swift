import SwiftUI

struct DeletableTimerCard: View {
    @ObservedObject var manager: TimerManager
    let timer: TimerData
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete button background (only visible when swiped)
            if offset < 0 {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            manager.deleteTimer(id: timer.id)
                        }
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                            .frame(width: 80)
                            .frame(maxHeight: .infinity)
                    }
                    .background(Color.red)
                    .cornerRadius(20)
                }
            }
            
            // Timer card with background to hide delete button (only if no background image)
            TimerCardView(manager: manager, timer: timer)
                .background(manager.backgroundImage == nil ? manager.backgroundColor : Color.clear)
                .cornerRadius(20)
                .offset(x: offset)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { gesture in
                            // Only allow horizontal left swipe
                            if gesture.translation.width < 0 && abs(gesture.translation.width) > abs(gesture.translation.height) {
                                offset = gesture.translation.width
                                isSwiping = true
                            }
                        }
                        .onEnded { gesture in
                            withAnimation(.spring()) {
                                // If swiped far enough, show delete button
                                if gesture.translation.width < -80 {
                                    offset = -80
                                } else {
                                    offset = 0
                                }
                                isSwiping = false
                            }
                        }
                )
        }
        .padding(.horizontal, 20)
    }
}

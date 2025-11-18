import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    let baseColor: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Base glass layer
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 20)
                        )
                    
                    // Inner highlight
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 8)
    }
}

extension View {
    func liquidGlass(color: Color = .blue) -> some View {
        self.modifier(LiquidGlassModifier(baseColor: color))
    }
}

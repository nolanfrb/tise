import SwiftUI

/// A decorative SF Symbol painted in a two-color gradient with a neon halo.
struct GlowSymbol: View {
    let name: String
    let colors: [Color]
    var size: CGFloat = 72

    var body: some View {
        Image(systemName: name)
            .font(AppType.symbol(size))
            .foregroundStyle(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: (colors.last ?? .clear).opacity(0.75), radius: size / 4)
            .accessibilityHidden(true)
    }
}

#Preview("Glow symbols") {
    HStack(spacing: 24) {
        GlowSymbol(name: "cube.fill", colors: [Color(hex: 0x7FE3FF), Color(hex: 0x3B6BFF)])
        GlowSymbol(name: "flame.fill", colors: [Color(hex: 0xFFB347), Color(hex: 0xFF2E63)])
    }
    .padding()
    .appPreview()
}

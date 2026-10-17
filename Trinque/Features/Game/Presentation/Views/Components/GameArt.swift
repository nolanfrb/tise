import SwiftUI

/// The neon glyphs that stand for a game, on its tile and on the turn card.
struct GameArt: View {
    let game: Game
    var size: CGFloat = 76

    var body: some View {
        switch game {
        case .truthOrDare:
            HStack(spacing: -size / 8) {
                GlowSymbol(name: "questionmark", colors: [Color(hex: 0x8FA2FF), AppColors.truth], size: size)
                GlowSymbol(name: "exclamationmark", colors: [AppColors.accentSoft, AppColors.accent], size: size)
            }
        case .neverHaveIEver:
            GlowSymbol(name: "hand.raised.fingers.spread.fill", colors: [Color(hex: 0xFFE07A), Color(hex: 0xFF9F1C)], size: size)
        }
    }
}

#Preview("Game art") {
    HStack(spacing: 40) {
        GameArt(game: .truthOrDare)
        GameArt(game: .neverHaveIEver)
    }
    .trinquePreview()
}

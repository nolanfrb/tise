import SwiftUI

/// The night-and-neon palette every screen draws from.
enum AppColors {
    static let background = Color(hex: 0x060C1C)
    static let cardTop = Color(hex: 0x17213C)
    static let cardBottom = Color(hex: 0x0E1528)
    static let panelFill = Color(hex: 0x0B1236)
    static let tileFill = Color(hex: 0x120A2A)
    static let stroke = Color(hex: 0x323443)

    static let accent = Color(hex: 0xEF5587)
    static let accentEdge = Color(hex: 0xAB2A6D)
    static let accentSoft = Color(hex: 0xF78DB0)
    static let truth = Color(hex: 0x5B6CD8)
    static let truthEdge = Color(hex: 0x3B479E)
    static let never = Color(hex: 0xFFC83D)

    static let textPrimary = Color.white
    static let textSecondary = Color(hex: 0xB0B3BC)
    static let textTertiary = Color(hex: 0x6F7581)
}

extension Color {
    /// A color from a `0xRRGGBB` literal.
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

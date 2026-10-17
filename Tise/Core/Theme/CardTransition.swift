import SwiftUI

/// The one transition of the app: a dealt card slides in as the previous one slides away.
struct CardTransition: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.transition(reduceMotion ? .opacity : Self.deal)
    }

    private static let deal = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
}

extension View {
    /// Animates this card in and out like a dealt card.
    func cardTransition() -> some View {
        modifier(CardTransition())
    }
}

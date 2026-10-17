import SwiftUI

/// The rounded, softly lit surface a dealt card sits on, with the rest of the deck peeking underneath.
struct CardSurface: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                shape.fill(
                    LinearGradient(
                        colors: [AppColors.cardTop, AppColors.cardBottom],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            )
            .overlay(shape.strokeBorder(.white.opacity(0.06)))
            .background(shape.fill(AppColors.cardBottom.opacity(0.7)).padding(.horizontal, 14).offset(y: 14))
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
    }
}

extension View {
    /// Places this content on a dealt-card surface.
    func cardSurface() -> some View {
        modifier(CardSurface())
    }
}

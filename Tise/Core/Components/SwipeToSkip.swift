import SwiftUI

/// Lets a card be thrown off to the left to skip it, Tinder-style.
struct SwipeToSkip: ViewModifier {
    let onSkip: () -> Void

    @State private var offset = CGSize.zero
    @State private var isLeaving = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let skipDistance: CGFloat = 110
    private static let skipFling: CGFloat = 260
    private static let exitDistance: CGFloat = 700
    private static let maxTilt = 12.0

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                SkipStamp()
                    .opacity(progress)
                    .padding(28)
            }
            .offset(x: offset.width, y: offset.height / 4)
            .rotationEffect(.degrees(reduceMotion ? 0 : tilt), anchor: .bottom)
            .gesture(drag)
            .accessibilityAction(named: Text("Passer la carte"), skip)
            .sensoryFeedback(.impact(weight: .medium), trigger: isLeaving) { _, leaving in leaving }
    }

    private var progress: Double {
        min(max(-offset.width / Self.skipDistance, 0), 1)
    }

    private var tilt: Double {
        min(max(offset.width / 20, -Self.maxTilt), Self.maxTilt)
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                guard !isLeaving else { return }
                offset = CGSize(width: min(value.translation.width, 40), height: value.translation.height)
            }
            .onEnded { value in
                guard !isLeaving else { return }
                let isThrown = value.translation.width < -Self.skipDistance || value.predictedEndTranslation.width < -Self.skipFling
                if isThrown {
                    skip()
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        offset = .zero
                    }
                }
            }
    }

    private func skip() {
        isLeaving = true
        withAnimation(.easeIn(duration: 0.22)) {
            offset = CGSize(width: -Self.exitDistance, height: offset.height)
        } completion: {
            onSkip()
        }
    }
}

/// The red stamp that grows on a card as it is dragged toward a skip.
private struct SkipStamp: View {
    var body: some View {
        Label("Passer", systemImage: "xmark")
            .font(AppType.headline)
            .foregroundStyle(AppColors.skip)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .overlay(Capsule().strokeBorder(AppColors.skip, lineWidth: 3))
            .rotationEffect(.degrees(14))
            .accessibilityHidden(true)
    }
}

extension View {
    /// Makes this card skippable by throwing it off to the left.
    func swipeToSkip(onSkip: @escaping () -> Void) -> some View {
        modifier(SwipeToSkip(onSkip: onSkip))
    }
}

import SwiftUI

/// The pink chip that tells how many sips a card is worth.
struct SipsChip: View {
    let count: Int
    let kind: PromptKind

    var body: some View {
        (kind == .statement ? Text("\(count) tises") : Text("Refus : \(count) tises"))
            .font(AppType.tag)
            .foregroundStyle(AppColors.accentSoft)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(AppColors.accent.opacity(0.18), in: .capsule)
            .overlay(Capsule().strokeBorder(AppColors.accent.opacity(0.35)))
    }
}

#Preview("Sips chips") {
    VStack(spacing: 12) {
        SipsChip(count: 1, kind: .statement)
        SipsChip(count: 3, kind: .dare)
    }
    .appPreview()
}

import SwiftUI

/// The pink chip that tells how many sips a card is worth.
struct SipsChip: View {
    let count: Int
    let kind: PromptKind

    var body: some View {
        label
            .font(AppType.tag)
            .foregroundStyle(AppColors.accentSoft)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(AppColors.accent.opacity(0.18), in: .capsule)
            .overlay(Capsule().strokeBorder(AppColors.accent.opacity(0.35)))
    }

    private var label: Text {
        switch kind {
        case .statement: Text("\(count) tises")
        case .truth, .dare, .ask: Text("Refus : \(count) tises")
        case .vote: Text("Majorité : \(count) tises")
        case .point: Text("Le plus pointé : \(count) tises")
        }
    }
}

#Preview("Sips chips") {
    VStack(spacing: 12) {
        SipsChip(count: 1, kind: .statement)
        SipsChip(count: 3, kind: .dare)
    }
    .appPreview()
}

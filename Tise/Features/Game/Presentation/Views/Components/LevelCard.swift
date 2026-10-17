import SwiftUI

/// A selectable level of the party: its glyph, its name and what to expect.
struct LevelCard: View {
    let choice: LevelChoice
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 18) {
                GlowSymbol(name: choice.symbol, colors: choice.colors, size: 58)
                    .frame(width: 96)
                VStack(spacing: 8) {
                    Text(choice.title)
                        .font(AppType.title)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(choice.subtitle)
                        .font(AppType.body)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 16)
            .background(shape.fill(AppColors.panelFill))
            .overlay(shape.strokeBorder(isSelected ? AppColors.accent : AppColors.stroke.opacity(0.6), lineWidth: isSelected ? 3 : 1))
            .shadow(color: isSelected ? AppColors.accent.opacity(0.35) : .clear, radius: 16)
            .contentShape(shape)
        }
        .buttonStyle(.pressable)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
    }
}

#Preview("Level cards") {
    VStack(spacing: 16) {
        LevelCard(choice: .soft, isSelected: true) {}
        LevelCard(choice: .hot, isSelected: false) {}
        LevelCard(choice: .mixed, isSelected: false) {}
    }
    .padding()
    .appPreview()
}

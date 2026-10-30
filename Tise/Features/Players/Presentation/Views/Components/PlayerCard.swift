import SwiftUI

/// A player at the table: a tap switches their sex, the cross removes them.
struct PlayerCard: View {
    let player: Player
    let onToggleGender: () -> Void
    let onRemove: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onToggleGender) {
                HStack(spacing: 12) {
                    if !dynamicTypeSize.isAccessibilitySize {
                        PlayerAvatar(player: player)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: player.name)
                            .font(AppType.headline)
                            .foregroundStyle(AppColors.textPrimary)
                        Label(player.gender.title, systemImage: player.gender.symbol)
                            .font(AppType.tag)
                            .foregroundStyle(player.gender.tint)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.pressable)
            .accessibilityHint("Change entre femme et homme")
            Button("Retirer \(player.name)", systemImage: "xmark", action: onRemove)
                .labelStyle(.iconOnly)
                .font(AppType.tag)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                .foregroundStyle(AppColors.textSecondary)
                .frame(width: 44, height: 44)
                .contentShape(.rect)
        }
        .padding(.leading, 12)
        .padding(.vertical, 10)
        .background(AppColors.panelFill, in: .rect(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(player.gender.tint.opacity(0.45), lineWidth: 1.5))
    }
}

/// The round initial standing for a player, in the color of their sex.
private struct PlayerAvatar: View {
    let player: Player

    var body: some View {
        Text(verbatim: String(player.name.prefix(1)).uppercased())
            .font(AppType.headline)
            .foregroundStyle(AppColors.textPrimary)
            .frame(width: 44, height: 44)
            .background(
                LinearGradient(colors: [player.gender.tint, player.gender.tint.opacity(0.55)], startPoint: .topLeading, endPoint: .bottomTrailing),
                in: .circle
            )
            .accessibilityHidden(true)
    }
}

private var previewCards: some View {
    VStack(spacing: 12) {
        ForEach(PlayerPreviewData.players) { player in
            PlayerCard(player: player, onToggleGender: {}, onRemove: {})
        }
        PlayerCard(player: Player(name: "Marie-Charlotte", gender: .female), onToggleGender: {}, onRemove: {})
        PlayerCard(player: Player(name: "Maximilien-Alexandre", gender: .male), onToggleGender: {}, onRemove: {})
    }
    .padding()
}

#Preview("Player cards") {
    previewCards
        .appPreview()
}

#Preview("Player cards — largest text") {
    previewCards
        .dynamicTypeSize(.accessibility5)
        .appPreview()
}

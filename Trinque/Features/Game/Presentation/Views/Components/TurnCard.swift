import SwiftUI

/// The card that hands the turn to a player, who then picks truth or dare.
struct TurnCard: View {
    let player: Player

    var body: some View {
        VStack(spacing: 20) {
            GameArt(game: .truthOrDare, size: 70)
            Text(verbatim: player.name)
                .font(AppType.prompt)
                .foregroundStyle(AppColors.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Action ou vérité ?")
                .font(AppType.headline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(24)
        .cardSurface()
        .accessibilityElement(children: .combine)
    }
}

/// What shows when no card of the bank fits this table any more.
struct EmptyDeckCard: View {
    var body: some View {
        VStack(spacing: 14) {
            GlowSymbol(name: "rectangle.stack.fill", colors: [AppColors.textSecondary, AppColors.textTertiary], size: 52)
            Text("Plus de carte pour cette table")
                .font(AppType.headline)
                .foregroundStyle(AppColors.textPrimary)
            Text("Reviens en arrière pour changer de niveau ou ajouter des joueurs.")
                .font(AppType.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .multilineTextAlignment(.center)
        .padding(24)
        .cardSurface()
    }
}

#Preview("Turn card") {
    if let player = PlayerPreviewData.players.first {
        TurnCard(player: player)
            .padding()
            .trinquePreview()
    }
}

#Preview("Empty deck") {
    EmptyDeckCard()
        .padding()
        .trinquePreview()
}

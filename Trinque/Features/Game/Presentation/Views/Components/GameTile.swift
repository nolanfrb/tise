import SwiftUI

/// The tile that opens one game from the home screen.
struct GameTile: View {
    let game: Game

    var body: some View {
        VStack(spacing: 18) {
            GameArt(game: game, size: 64)
                .frame(maxHeight: .infinity)
            VStack(spacing: 0) {
                Text(game.tileLead)
                    .font(AppType.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Text(game.tileHeadline)
                    .font(AppType.title)
                    .foregroundStyle(game.headlineColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 220)
        .background(
            shape.fill(
                RadialGradient(
                    colors: [game.headlineColor.opacity(0.28), AppColors.tileFill],
                    center: .top,
                    startRadius: 10,
                    endRadius: 220
                )
            )
        )
        .overlay(shape.strokeBorder(AppColors.stroke, lineWidth: 2))
        .contentShape(shape)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(game.title)
        .accessibilityAddTraits(.isButton)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
    }
}

#Preview("Game tiles") {
    HStack(spacing: 14) {
        GameTile(game: .truthOrDare)
        GameTile(game: .neverHaveIEver)
    }
    .padding()
    .trinquePreview()
}

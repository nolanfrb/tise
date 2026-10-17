import SwiftUI

/// The launch button and, while players are missing, how many more the table needs.
struct LaunchBar: View {
    let setup: GameSetup
    let onNeedPlayers: () -> Void

    @Environment(PlayerRoster.self) private var roster

    var body: some View {
        VStack(spacing: 12) {
            if roster.canStart {
                NavigationLink(value: setup) {
                    Text("Lancer")
                }
            } else {
                Text("Ajoute encore \(roster.missingCount) joueurs pour lancer la partie")
                    .font(AppType.caption)
                    .foregroundStyle(AppColors.textTertiary)
                    .multilineTextAlignment(.center)
                Button("Lancer", action: onNeedPlayers)
            }
        }
        .buttonStyle(.raised)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

#Preview("Launch bar — ready") {
    NavigationStack {
        LaunchBar(setup: GameSetup(game: .truthOrDare, level: .soft)) {}
            .trinquePreview()
    }
}

import SwiftUI

/// The launch button and, while players are missing, how many more the table needs.
struct LaunchBar: View {
    let setup: GameSetup

    @Environment(PlayerRoster.self) private var roster

    var body: some View {
        VStack(spacing: 12) {
            if setup.audience.accepts(playerCount: roster.players.count) {
                NavigationLink(value: setup) {
                    Text("Lancer")
                }
            } else {
                missingPlayersHint
                    .font(AppType.caption)
                    .foregroundStyle(AppColors.textTertiary)
                    .multilineTextAlignment(.center)
                NavigationLink(value: PlayersRoute()) {
                    Text("Lancer")
                }
            }
        }
        .buttonStyle(.raised)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private var missingPlayersHint: Text {
        roster.canStart
            ? Text("Le mode Couple se joue à \(Audience.coupleSize) joueurs exactement")
            : Text("Ajoute encore \(roster.missingCount) joueurs pour lancer la partie")
    }
}

#Preview("Launch bar — ready") {
    NavigationStack {
        LaunchBar(setup: GameSetup(game: .truthOrDare, level: .soft))
            .appPreview()
    }
}

import SwiftUI

/// The pink button that shows how many players are at the table and opens the roster page.
struct PlayersButton: View {
    @Environment(PlayerRoster.self) private var roster

    var body: some View {
        NavigationLink(value: PlayersRoute()) {
            Label("Joueurs (\(roster.players.count))", systemImage: "person.2.fill")
        }
        .buttonStyle(.raisedCompact)
    }
}

#Preview("Players button") {
    NavigationStack {
        PlayersButton()
    }
    .appPreview()
}

import SwiftUI

/// The pink button that shows how many players are at the table and opens the roster.
struct PlayersButton: View {
    let action: () -> Void

    @Environment(PlayerRoster.self) private var roster

    var body: some View {
        Button(action: action) {
            Label("Joueurs (\(roster.players.count))", systemImage: "person.2.fill")
        }
        .buttonStyle(.raisedCompact)
    }
}

#Preview("Players button") {
    PlayersButton {}
        .trinquePreview()
}

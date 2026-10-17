import SwiftUI

/// One player of the roster, whose sex can be changed in place.
struct PlayerRow: View {
    let player: Player

    @Environment(PlayerRoster.self) private var roster

    var body: some View {
        Picker(selection: gender) {
            ForEach(Gender.allCases, id: \.self) { gender in
                Text(gender.title)
            }
        } label: {
            Text(verbatim: player.name)
        }
        .pickerStyle(.menu)
    }

    private var gender: Binding<Gender> {
        Binding {
            player.gender
        } set: { gender in
            roster.setGender(gender, for: player.id)
        }
    }
}

#Preview("Player row") {
    List {
        ForEach(PlayerPreviewData.players) { player in
            PlayerRow(player: player)
        }
    }
    .appPreview()
}

import SwiftUI

/// The sheet where players join the table, each with a name and a sex.
struct PlayersSheet: View {
    @Environment(PlayerRoster.self) private var roster
    @Environment(\.dismiss) private var dismiss

    @State private var draftName = ""
    @State private var draftGender = Gender.female
    @FocusState private var isNameFocused: Bool

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Ajoute un joueur", text: $draftName)
                        .focused($isNameFocused)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .onSubmit(addPlayer)
                    Picker("Sexe", selection: $draftGender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    Button("Ajouter le joueur", systemImage: "plus.circle.fill", action: addPlayer)
                        .disabled(!Player.isValidName(draftName))
                }

                Section {
                    ForEach(roster.players) { player in
                        PlayerRow(player: player)
                    }
                    .onDelete(perform: roster.remove(at:))
                } header: {
                    Text("À table")
                } footer: {
                    if !roster.canStart {
                        Text("Il faut au moins \(Game.minimumPlayers) joueurs pour lancer une partie.")
                    }
                }
            }
            .navigationTitle("Joueurs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isNameFocused = roster.players.isEmpty
            }
        }
        .presentationDragIndicator(.visible)
    }

    private func addPlayer() {
        guard roster.add(name: draftName, gender: draftGender) else { return }
        draftName = ""
        isNameFocused = true
    }
}

#Preview("Players sheet") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            PlayersSheet()
                .trinquePreview()
        }
        .trinquePreview()
}

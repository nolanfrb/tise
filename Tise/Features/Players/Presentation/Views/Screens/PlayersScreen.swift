import SwiftUI

/// The route to the roster page, pushed from any players button.
struct PlayersRoute: Hashable {}

/// The roster page: type a name, pick a sex, and the player joins the table.
struct PlayersScreen: View {
    @Environment(PlayerRoster.self) private var roster
    @Environment(\.dismiss) private var dismiss

    @State private var draftName = ""
    @State private var draftGender = Gender.female
    @FocusState private var isNameFocused: Bool

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                PlayerNameField(name: $draftName, isFocused: $isNameFocused, onSubmit: addPlayer)
                GenderPicker(selection: $draftGender)
                if roster.players.isEmpty {
                    EmptyRosterNote()
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(roster.players) { player in
                            PlayerCard(
                                player: player,
                                onToggleGender: { roster.setGender(player.gender.opposite, for: player.id) },
                                onRemove: { remove(player) }
                            )
                        }
                    }
                }
                if !roster.canStart && !roster.players.isEmpty {
                    Text("Il faut au moins \(Game.minimumPlayers) joueurs pour lancer une partie.")
                        .font(AppType.caption)
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaBar(edge: .bottom) {
            Button("Terminé") { dismiss() }
                .buttonStyle(.raised)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
        }
        .background(AppColors.background)
        .navigationTitle("Joueurs")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: roster.players.count) { old, new in new > old }
        .onAppear {
            isNameFocused = roster.players.isEmpty
        }
    }

    private func addPlayer() {
        withAnimation(.snappy) {
            guard roster.add(name: draftName, gender: draftGender) else { return }
            draftName = ""
        }
        isNameFocused = true
    }

    private func remove(_ player: Player) {
        guard let index = roster.players.firstIndex(of: player) else { return }
        withAnimation(.snappy) {
            roster.remove(at: IndexSet(integer: index))
        }
    }
}

/// What the page shows before anyone has joined.
private struct EmptyRosterNote: View {
    var body: some View {
        VStack(spacing: 12) {
            GlowSymbol(name: "person.2.fill", colors: [AppColors.accentSoft, AppColors.accent], size: 46)
            Text("Personne à table pour l'instant")
                .font(AppType.headline)
                .foregroundStyle(AppColors.textPrimary)
            Text("Il faut au moins \(Game.minimumPlayers) joueurs pour lancer une partie.")
                .font(AppType.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview("Players — four at the table") {
    NavigationStack {
        PlayersScreen()
    }
    .appPreview()
}

#Preview("Players — empty") {
    NavigationStack {
        PlayersScreen()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
    .environment(PlayerRoster(repository: AppContainer.preview.playerRepository, players: []))
    .preferredColorScheme(.dark)
}

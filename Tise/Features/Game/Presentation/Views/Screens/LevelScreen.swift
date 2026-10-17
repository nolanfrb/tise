import SwiftUI

/// The screen where the table picks how spicy the party gets, then launches it.
struct LevelScreen: View {
    let game: Game

    @State private var level = LevelChoice.soft
    @State private var isShowingPlayers = false
    @State private var isShowingRules = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                PlayersButton { isShowingPlayers = true }
                ForEach(LevelChoice.allCases, id: \.self) { choice in
                    LevelCard(choice: choice, isSelected: level == choice) {
                        level = choice
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .safeAreaBar(edge: .bottom) {
            LaunchBar(setup: GameSetup(game: game, level: level)) {
                isShowingPlayers = true
            }
        }
        .background(AppColors.background)
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Règles", systemImage: "questionmark") {
                    isShowingRules = true
                }
            }
        }
        .alert(game.title, isPresented: $isShowingRules) {
            Button("Compris", role: .cancel) {}
        } message: {
            Text(game.rules)
        }
        .sheet(isPresented: $isShowingPlayers) {
            PlayersSheet()
        }
    }
}

#Preview("Levels — truth or dare") {
    NavigationStack {
        LevelScreen(game: .truthOrDare)
    }
    .appPreview()
}

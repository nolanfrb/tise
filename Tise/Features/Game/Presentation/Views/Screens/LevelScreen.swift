import SwiftUI

/// The screen where the table picks how spicy the party gets, then launches it.
struct LevelScreen: View {
    let game: Game

    @State private var level = LevelChoice.soft
    @State private var audience = Audience.friends
    @State private var isShowingRules = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                PlayersButton()
                if game.audiences.count > 1 {
                    Picker("Public", selection: $audience) {
                        ForEach(game.audiences, id: \.self) { audience in
                            Text(audience.title)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                ForEach(LevelChoice.allCases, id: \.self) { choice in
                    LevelCard(choice: choice, game: game, isSelected: level == choice) {
                        level = choice
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .safeAreaBar(edge: .bottom) {
            LaunchBar(setup: GameSetup(game: game, level: level, audience: audience))
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
    }
}

#Preview("Levels — truth or dare") {
    NavigationStack {
        LevelScreen(game: .truthOrDare)
    }
    .appPreview()
}

#Preview("Levels — sans tact") {
    NavigationStack {
        LevelScreen(game: .blunt)
    }
    .appPreview()
}

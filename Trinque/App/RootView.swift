import SwiftUI

/// The composition root: the session roster, the navigation stack and every destination it can push.
struct RootView: View {
    let container: AppContainer

    @State private var roster: PlayerRoster

    init(container: AppContainer) {
        self.container = container
        _roster = State(initialValue: PlayerRoster(repository: container.playerRepository))
    }

    var body: some View {
        NavigationStack {
            HomeScreen()
                .navigationDestination(for: Game.self) { game in
                    LevelScreen(game: game)
                }
                .navigationDestination(for: GameSetup.self) { setup in
                    GameScreen(setup: setup, repository: container.promptRepository, roster: roster)
                }
        }
        .environment(roster)
        .tint(AppColors.accent)
        .preferredColorScheme(.dark)
    }
}

#Preview("App — full") {
    RootView(container: .preview)
}

import SwiftUI

/// The party itself: one card at a time, dealt to the table.
struct GameScreen: View {
    @State private var viewModel: GameViewModel

    init(setup: GameSetup, repository: PromptRepository, roster: PlayerRoster) {
        _viewModel = State(initialValue: GameViewModel(setup: setup, repository: repository, roster: roster))
    }

    var body: some View {
        ViewStateView(state: viewModel.state, onRetry: retry) {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } content: { round in
            RoundView(round: round, onChoose: choose, onNext: next)
        }
        .background(AppColors.background)
        .navigationTitle(viewModel.setup.game.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ProgressView(value: viewModel.progress)
                    .tint(AppColors.accent)
                    .frame(width: 180)
                    .accessibilityLabel("Cartes jouées")
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private func choose(_ kind: PromptKind) {
        withAnimation(.snappy) {
            viewModel.choose(kind)
        }
    }

    private func next() {
        withAnimation(.snappy) {
            viewModel.next()
        }
    }

    private func retry() {
        Task {
            await viewModel.retry()
        }
    }
}

#Preview("Game — truth or dare, mixed") {
    NavigationStack {
        GameScreen(
            setup: GameSetup(game: .truthOrDare, level: .mixed),
            repository: AppContainer.preview.promptRepository,
            roster: PlayerRoster(repository: AppContainer.preview.playerRepository, players: PlayerPreviewData.players)
        )
    }
    .appPreview()
}

#Preview("Game — never have I ever, soft") {
    NavigationStack {
        GameScreen(
            setup: GameSetup(game: .neverHaveIEver, level: .soft),
            repository: AppContainer.preview.promptRepository,
            roster: PlayerRoster(repository: AppContainer.preview.playerRepository, players: PlayerPreviewData.players)
        )
    }
    .appPreview()
}

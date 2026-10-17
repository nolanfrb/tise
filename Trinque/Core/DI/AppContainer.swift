import Foundation

/// The app's dependency graph, built once at launch and handed to the composition root.
final class AppContainer {
    let promptRepository: PromptRepository
    let playerRepository: PlayerRepository

    init(promptRepository: PromptRepository, playerRepository: PlayerRepository) {
        self.promptRepository = promptRepository
        self.playerRepository = playerRepository
    }

    static let live = AppContainer(
        promptRepository: PromptRepository(bundle: .main),
        playerRepository: PlayerRepository(defaults: .standard)
    )

    static let preview: AppContainer = {
        let defaults = UserDefaults(suiteName: "com.nolanfribault.trinque.preview") ?? .standard
        let players = PlayerRepository(defaults: defaults)
        players.save(PlayerPreviewData.players)
        return AppContainer(promptRepository: PromptRepository(bundle: .main), playerRepository: players)
    }()
}

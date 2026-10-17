import Foundation

/// Reads the card bank shipped inside the app.
nonisolated final class PromptRepository: Sendable {
    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    @concurrent
    func prompts() async throws -> [Prompt] {
        guard let url = bundle.url(forResource: "prompts", withExtension: "json") else {
            throw PromptBankError.missing
        }
        let cards = try JSONDecoder().decode([PromptDTO].self, from: Data(contentsOf: url))
        return cards.compactMap { $0.toDomain() }
    }
}

/// Why the card bank could not be read.
nonisolated enum PromptBankError: Error {
    case missing
}

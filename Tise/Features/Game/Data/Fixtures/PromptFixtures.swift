import Foundation

/// Bank-shaped cards that previews decode through [PromptDTO].
nonisolated enum PromptFixtures {
    static let cards = Data(
        """
        [
          {"id": "fx-statement", "kind": "statement", "level": "soft", "sips": 2, "player": "any", "target": "none",
           "text": "envoyé un vocal de six minutes à quelqu'un qui attendait un oui ou un non"},
          {"id": "fx-truth", "kind": "truth", "level": "soft", "sips": 2, "player": "any", "target": "any",
           "text": "Qu'est-ce que tu n'as jamais osé dire à {target} ?"},
          {"id": "fx-dare", "kind": "dare", "level": "hot", "sips": 3, "player": "any", "target": "opposite",
           "text": "Murmure à l'oreille de {target} pourquoi tu {t:le|la} trouves {t:craquant|craquante}"},
          {"id": "fx-ask", "kind": "ask", "level": "soft", "audience": "friends", "sips": 2, "player": "any", "target": "none",
           "text": "{player}, qui ici finit toujours par raconter la même anecdote ?"}
        ]
        """.utf8
    )
}

/// The cards previews show, decoded from [PromptFixtures] and dealt to [PlayerPreviewData].
nonisolated enum PromptPreviewData {
    static let prompts: [Prompt] = {
        let cards = (try? JSONDecoder().decode([PromptDTO].self, from: PromptFixtures.cards)) ?? []
        return cards.compactMap { $0.toDomain() }
    }()

    static func draw(_ kind: PromptKind) -> Draw? {
        guard let prompt = prompts.first(where: { $0.kind == kind }) else { return nil }
        let players = PlayerPreviewData.players
        let player = players.first
        return Draw(prompt: prompt, player: player, target: prompt.target.candidates(for: player, among: players).first)
    }
}

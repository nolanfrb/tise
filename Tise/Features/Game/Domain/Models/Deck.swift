/// A card dealt to the table: the prompt, the player it is for and the player it names.
nonisolated struct Draw: Hashable, Sendable {
    let prompt: Prompt
    let player: Player?
    let target: Player?

    var text: RenderedPrompt {
        prompt.rendered(for: player, target: target)
    }
}

/// The cards of one party, dealt at random without repeats, warming up from soft to hot when both are in play.
nonisolated struct Deck: Sendable {
    private static let openingHotShare = 0.2
    private static let peakHotShare = 0.8
    private static let cardsToPeak = 40.0

    private let prompts: [Prompt]
    private let isMixed: Bool
    private var dealt: Set<Prompt.ID> = []
    private var dealtCount = 0

    init(prompts: [Prompt], setup: GameSetup) {
        let levels = setup.level.levels
        self.prompts = prompts.filter {
            setup.game.kinds.contains($0.kind) && levels.contains($0.level) && $0.audience == setup.audience
        }
        isMixed = levels.count > 1
    }

    /// The share of the deck dealt since the last reshuffle.
    var progress: Double {
        prompts.isEmpty ? 0 : Double(dealt.count) / Double(prompts.count)
    }

    /// Deals a card of one of `kinds` to `player`, reshuffling them back in once every playable card has come out.
    mutating func draw(_ kinds: Set<PromptKind>, for player: Player?, among players: [Player]) -> Draw? {
        let playable = prompts.filter { kinds.contains($0.kind) && $0.isPlayable(by: player, among: players) }
        let fresh = playable.filter { !dealt.contains($0.id) }
        if fresh.isEmpty {
            dealt.subtract(playable.map(\.id))
        }
        guard let prompt = warmedUp(fresh.isEmpty ? playable : fresh).randomElement() else { return nil }
        dealt.insert(prompt.id)
        dealtCount += 1
        return Draw(prompt: prompt, player: player, target: prompt.target.candidates(for: player, among: players).randomElement())
    }

    /// The cards of the level this deal leans to, so a mixed party starts soft and heats up.
    private func warmedUp(_ pool: [Prompt]) -> [Prompt] {
        guard isMixed else { return pool }
        let level: Level = Double.random(in: 0..<1) < hotShare ? .hot : .soft
        let leaning = pool.filter { $0.level == level }
        return leaning.isEmpty ? pool : leaning
    }

    private var hotShare: Double {
        min(Self.peakHotShare, Self.openingHotShare + Double(dealtCount) / Self.cardsToPeak * (Self.peakHotShare - Self.openingHotShare))
    }
}

/// One of the two games of the app.
nonisolated enum Game: String, CaseIterable, Hashable, Sendable {
    case truthOrDare
    case neverHaveIEver

    static let minimumPlayers = 2

    /// The kinds of card this game deals.
    var kinds: Set<PromptKind> {
        switch self {
        case .truthOrDare: [.truth, .dare]
        case .neverHaveIEver: [.statement]
        }
    }
}

/// How spicy a card is.
nonisolated enum Level: String, Hashable, Sendable {
    case soft
    case hot
}

/// The level a party is played at: one level, or both mixed and warming up as the party goes.
nonisolated enum LevelChoice: String, CaseIterable, Hashable, Sendable {
    case soft
    case hot
    case mixed

    var levels: Set<Level> {
        switch self {
        case .soft: [.soft]
        case .hot: [.hot]
        case .mixed: [.soft, .hot]
        }
    }
}

/// The game and the level a party is launched with.
nonisolated struct GameSetup: Hashable, Sendable {
    let game: Game
    let level: LevelChoice
}

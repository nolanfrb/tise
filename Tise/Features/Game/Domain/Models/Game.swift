/// One of the games of the app.
nonisolated enum Game: String, CaseIterable, Hashable, Sendable {
    case truthOrDare
    case neverHaveIEver
    case blunt
    case ten

    static let minimumPlayers = 2

    /// The kinds of card this game deals.
    var kinds: Set<PromptKind> {
        switch self {
        case .truthOrDare: [.truth, .dare]
        case .neverHaveIEver: [.statement]
        case .blunt: [.ask, .vote, .point]
        case .ten: [.ten]
        }
    }

    /// Whether each round belongs to one player, the turn passing around the table.
    var rotatesTurns: Bool {
        self != .neverHaveIEver
    }

    /// The audiences this game can be played with.
    var audiences: [Audience] {
        self == .blunt ? [.friends, .couple] : [.friends]
    }
}

/// Who sits at the table: a group of friends, or a couple playing on their own.
nonisolated enum Audience: String, Hashable, Sendable {
    case friends
    case couple

    static let coupleSize = 2

    func accepts(playerCount: Int) -> Bool {
        switch self {
        case .friends: playerCount >= Game.minimumPlayers
        case .couple: playerCount == Self.coupleSize
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

/// The game, the level and the audience a party is launched with.
nonisolated struct GameSetup: Hashable, Sendable {
    let game: Game
    let level: LevelChoice
    let audience: Audience

    init(game: Game, level: LevelChoice, audience: Audience = .friends) {
        self.game = game
        self.level = level
        self.audience = audience
    }
}

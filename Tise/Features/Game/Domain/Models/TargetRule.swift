/// Which players a card can be dealt to.
nonisolated enum PlayerRule: Hashable, Sendable {
    case anyone
    case only(Gender)

    func admits(_ player: Player) -> Bool {
        switch self {
        case .anyone: true
        case .only(let gender): player.gender == gender
        }
    }
}

/// Which other player a card names, relative to the player whose turn it is.
nonisolated enum TargetRule: Hashable, Sendable {
    case nobody
    case anyone
    case oppositeSex
    case sameSex
    case only(Gender)

    /// The players this rule can name when `player` holds the card.
    func candidates(for player: Player?, among players: [Player]) -> [Player] {
        let others = players.filter { $0.id != player?.id }
        switch self {
        case .nobody:
            return []
        case .anyone:
            return others
        case .oppositeSex:
            guard let player else { return [] }
            return others.filter { $0.gender == player.gender.opposite }
        case .sameSex:
            guard let player else { return [] }
            return others.filter { $0.gender == player.gender }
        case .only(let gender):
            return others.filter { $0.gender == gender }
        }
    }
}

import Foundation

/// Keeps the roster on the device, so the same table finds its players at the next party.
nonisolated final class PlayerRepository {
    private static let storageKey = "players"

    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func players() -> [Player] {
        guard
            let data = defaults.data(forKey: Self.storageKey),
            let stored = try? JSONDecoder().decode([PlayerDTO].self, from: data)
        else { return [] }
        return stored.compactMap { $0.toDomain() }
    }

    func save(_ players: [Player]) {
        guard let data = try? JSONEncoder().encode(players.map(PlayerDTO.init(player:))) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }
}

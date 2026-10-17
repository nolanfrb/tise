import Observation
import SwiftUI

/// The players at the table, shared by every screen and saved on each change.
@Observable
final class PlayerRoster {
    private(set) var players: [Player]

    private let repository: PlayerRepository

    init(repository: PlayerRepository) {
        self.repository = repository
        players = repository.players()
    }

    init(repository: PlayerRepository, players: [Player]) {
        self.repository = repository
        self.players = players
    }

    var missingCount: Int {
        max(Game.minimumPlayers - players.count, 0)
    }

    var canStart: Bool {
        missingCount == 0
    }

    /// Adds a player and reports whether the typed name was usable.
    @discardableResult
    func add(name: String, gender: Gender) -> Bool {
        guard let player = Player(typedName: name, gender: gender) else { return false }
        players.append(player)
        save()
        return true
    }

    func remove(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
        save()
    }

    func setGender(_ gender: Gender, for id: Player.ID) {
        guard let index = players.firstIndex(where: { $0.id == id }) else { return }
        players[index].gender = gender
        save()
    }

    private func save() {
        repository.save(players)
    }
}

import Foundation

/// A player as stored in the roster saved on the device.
nonisolated struct PlayerDTO: Codable, Sendable {
    let id: UUID
    let name: String
    let gender: String

    init(player: Player) {
        id = player.id
        name = player.name
        gender = player.gender.rawValue
    }

    func toDomain() -> Player? {
        Gender(rawValue: gender).map { Player(id: id, name: name, gender: $0) }
    }
}

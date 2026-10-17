import Foundation

/// A stored-shape roster that previews decode through [PlayerDTO].
nonisolated enum PlayerFixtures {
    static let roster = Data(
        """
        [
          {"id": "6B0C1F6E-2C59-4C5E-9E0B-1B9D2F7A0001", "name": "Léa", "gender": "female"},
          {"id": "6B0C1F6E-2C59-4C5E-9E0B-1B9D2F7A0002", "name": "Hugo", "gender": "male"},
          {"id": "6B0C1F6E-2C59-4C5E-9E0B-1B9D2F7A0003", "name": "Inès", "gender": "female"},
          {"id": "6B0C1F6E-2C59-4C5E-9E0B-1B9D2F7A0004", "name": "Malik", "gender": "male"}
        ]
        """.utf8
    )
}

/// The players previews show, decoded from [PlayerFixtures].
nonisolated enum PlayerPreviewData {
    static let players: [Player] = {
        let stored = (try? JSONDecoder().decode([PlayerDTO].self, from: PlayerFixtures.roster)) ?? []
        return stored.compactMap { $0.toDomain() }
    }()
}

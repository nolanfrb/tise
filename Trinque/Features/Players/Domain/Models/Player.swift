import Foundation

/// A person at the table, as the game addresses and targets them.
nonisolated struct Player: Identifiable, Hashable, Sendable {
    static let maximumNameLength = 20

    let id: UUID
    let name: String
    var gender: Gender

    init(id: UUID = UUID(), name: String, gender: Gender) {
        self.id = id
        self.name = name
        self.gender = gender
    }

    /// A player from a name as typed, or `nil` when nothing but spaces was typed.
    init?(typedName: String, gender: Gender) {
        let trimmed = typedName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.init(name: String(trimmed.prefix(Self.maximumNameLength)), gender: gender)
    }

    static func isValidName(_ typedName: String) -> Bool {
        !typedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

/// The sex a player enters, which picks the grammatical agreements and the gender-targeted cards.
nonisolated enum Gender: String, CaseIterable, Hashable, Sendable {
    case female
    case male

    var opposite: Gender {
        self == .male ? .female : .male
    }
}

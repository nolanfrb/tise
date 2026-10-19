import Foundation

/// One card as written in the bundled bank.
nonisolated struct PromptDTO: Decodable, Sendable {
    let id: String
    let kind: String
    let level: String
    let audience: String?
    let sips: Int
    let score: Int?
    let player: String
    let target: String
    let text: String

    func toDomain() -> Prompt? {
        guard
            let kind = PromptKind(rawValue: kind),
            let level = Level(rawValue: level),
            let audience = Audience(rawValue: audience ?? Audience.friends.rawValue),
            let player = Self.playerRule(player),
            let target = Self.targetRule(target)
        else { return nil }
        return Prompt(id: id, kind: kind, level: level, audience: audience, sips: sips, score: score, player: player, target: target, template: text)
    }

    private static func playerRule(_ raw: String) -> PlayerRule? {
        switch raw {
        case "any": .anyone
        case "male": .only(.male)
        case "female": .only(.female)
        default: nil
        }
    }

    private static func targetRule(_ raw: String) -> TargetRule? {
        switch raw {
        case "none": .nobody
        case "any": .anyone
        case "opposite": .oppositeSex
        case "same": .sameSex
        case "male": .only(.male)
        case "female": .only(.female)
        default: nil
        }
    }
}

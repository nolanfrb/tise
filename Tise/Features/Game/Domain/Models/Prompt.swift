/// The kind of card: a statement, a vote or a pointing for the whole table, or a truth, a dare or a blunt question for one player.
nonisolated enum PromptKind: String, Hashable, Sendable {
    case statement
    case truth
    case dare
    case ask
    case vote
    case point
    case ten
}

/// One card of the bank, before player names and agreements are filled in.
nonisolated struct Prompt: Identifiable, Hashable, Sendable {
    /// The words every statement card continues, in the language of the bank.
    static let statementLead = "Je n'ai jamais"

    /// The words a « C'est un 10 mais » card continues, with its starting score.
    static func tenLead(score: Int) -> String {
        "C'est un \(score), mais…"
    }

    let id: String
    let kind: PromptKind
    let level: Level
    let audience: Audience
    let sips: Int
    let score: Int?
    let player: PlayerRule
    let target: TargetRule
    let template: String

    /// Whether this card can be dealt to `player` with `players` at the table.
    func isPlayable(by player: Player?, among players: [Player]) -> Bool {
        if let player, !self.player.admits(player) { return false }
        return target == .nobody || !target.candidates(for: player, among: players).isEmpty
    }

    /// The card's text with `{player}`, `{target}`, `{p:…|…}`, `{t:…|…}` and `{x:…|…}` resolved for these players.
    func rendered(for player: Player?, target: Player?) -> RenderedPrompt {
        var segments: [RenderedPrompt.Segment] = []
        var rest = template[...]
        while let open = rest.firstIndex(of: "{"), let close = rest[open...].firstIndex(of: "}") {
            segments.append(.text(String(rest[..<open])))
            let segment = Self.resolve(rest[rest.index(after: open)..<close], player: player, target: target)
            if case .name(let name) = segment {
                Self.elide(&segments, before: name)
            }
            segments.append(segment)
            rest = rest[rest.index(after: close)...]
        }
        segments.append(.text(String(rest)))
        return RenderedPrompt(segments: segments.filter { $0 != .text("") })
    }

    private static let elidingWords = ["de", "que"]
    private static let elisionInitials: Set<Character> = ["a", "e", "i", "o", "u", "h", "à", "â", "é", "è", "ê", "ë", "î", "ï", "ô", "û", "ü"]

    /// Turns a trailing « de » or « que » into « d' » or « qu' » when the name that follows starts with a vowel sound.
    private static func elide(_ segments: inout [RenderedPrompt.Segment], before name: String) {
        guard
            let initial = name.lowercased().first,
            elisionInitials.contains(initial),
            case .text(let run)? = segments.last,
            elidingWords.contains(where: { run == "\($0) " || run.hasSuffix(" \($0) ") })
        else { return }
        segments[segments.count - 1] = .text(String(run.dropLast(2)) + "'")
    }

    /// The segment one template token stands for.
    private static func resolve(_ token: Substring, player: Player?, target: Player?) -> RenderedPrompt.Segment {
        if token == "target" {
            return .name(target?.name ?? "")
        }
        if token == "player" {
            return .name(player?.name ?? "")
        }
        let forms = token.dropFirst(2).split(separator: "|", omittingEmptySubsequences: false)
        guard forms.count == 2 else { return .text(String(token)) }
        return .text(String(agreementGender(of: token, player: player, target: target) == .female ? forms[1] : forms[0]))
    }

    /// The sex an agreement token follows: the target for `t:`, the player's opposite for `x:`, the player otherwise.
    private static func agreementGender(of token: Substring, player: Player?, target: Player?) -> Gender? {
        switch token.prefix(2) {
        case "t:": target?.gender
        case "x:": player?.gender.opposite
        default: player?.gender
        }
    }
}

/// A card's text ready to read, cut into plain runs and player names.
nonisolated struct RenderedPrompt: Hashable, Sendable {
    nonisolated enum Segment: Hashable, Sendable {
        case text(String)
        case name(String)
    }

    let segments: [Segment]

    var plainText: String {
        segments.map { segment in
            switch segment {
            case .text(let run), .name(let run): run
            }
        }
        .joined()
    }
}

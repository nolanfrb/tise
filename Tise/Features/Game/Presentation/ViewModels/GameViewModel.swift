import Observation

/// What the table is looking at, numbered so that every new round animates in.
struct Round: Equatable {
    enum Stage: Equatable {
        case choice(Player)
        case card(Draw)
        case exhausted
    }

    let number: Int
    let stage: Stage
}

/// Deals the cards of one party and passes the turn around the table.
@Observable
final class GameViewModel {
    let setup: GameSetup

    private(set) var state: ViewState<Round> = .loading

    private let repository: PromptRepository
    private let roster: PlayerRoster
    private var deck: Deck?
    private var turn = 0
    private var roundNumber = 0

    init(setup: GameSetup, repository: PromptRepository, roster: PlayerRoster) {
        self.setup = setup
        self.repository = repository
        self.roster = roster
    }

    var progress: Double {
        deck?.progress ?? 0
    }

    func load() async {
        guard deck == nil else { return }
        do {
            deck = Deck(prompts: try await repository.prompts(), setup: setup)
            turn = Int.random(in: 0..<max(roster.players.count, 1))
            startRound()
        } catch {
            state = .failed(error)
        }
    }

    func retry() async {
        state = .loading
        await load()
    }

    /// Deals the truth or the dare the current player picked.
    func choose(_ kind: PromptKind) {
        publish(deal(kind, for: currentPlayer))
    }

    /// Moves on to the next round, handing the turn to the next player in truth or dare.
    func next() {
        if setup.game == .truthOrDare {
            turn += 1
        }
        startRound()
    }

    private var currentPlayer: Player? {
        let players = roster.players
        return players.isEmpty ? nil : players[turn % players.count]
    }

    private func startRound() {
        switch setup.game {
        case .truthOrDare:
            publish(currentPlayer.map(Round.Stage.choice) ?? .exhausted)
        case .neverHaveIEver:
            publish(deal(.statement, for: nil))
        }
    }

    private func deal(_ kind: PromptKind, for player: Player?) -> Round.Stage {
        guard let draw = deck?.draw(kind, for: player, among: roster.players) else { return .exhausted }
        return .card(draw)
    }

    private func publish(_ stage: Round.Stage) {
        roundNumber += 1
        state = .loaded(Round(number: roundNumber, stage: stage))
    }
}

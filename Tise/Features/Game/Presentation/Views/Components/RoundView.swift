import SwiftUI

/// One round of the party: the card on the table and the buttons under it.
struct RoundView: View {
    let round: Round
    let onChoose: (PromptKind) -> Void
    let onSkip: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                RoundCard(stage: round.stage, onSkip: onSkip)
                    .id(round.number)
                    .cardTransition()
            }
            .frame(maxHeight: .infinity)
            RoundActions(stage: round.stage, onChoose: onChoose, onNext: onNext)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .sensoryFeedback(.impact(weight: .light), trigger: round.number)
    }
}

/// The card a stage puts on the table.
private struct RoundCard: View {
    let stage: Round.Stage
    let onSkip: () -> Void

    var body: some View {
        switch stage {
        case .choice(let player):
            TurnCard(player: player)
        case .card(let draw):
            PromptCard(draw: draw)
                .swipeToSkip(onSkip: onSkip)
        case .exhausted:
            EmptyDeckCard()
        }
    }
}

/// The buttons a stage offers: truth or dare to pick, or the next card.
private struct RoundActions: View {
    let stage: Round.Stage
    let onChoose: (PromptKind) -> Void
    let onNext: () -> Void

    var body: some View {
        switch stage {
        case .choice:
            HStack(spacing: 14) {
                Button("Vérité") { onChoose(.truth) }
                    .buttonStyle(.raised(tint: AppColors.truth, edge: AppColors.truthEdge))
                Button("Action") { onChoose(.dare) }
                    .buttonStyle(.raised)
            }
        case .card:
            Button("Suivant", action: onNext)
                .buttonStyle(.raised)
        case .exhausted:
            EmptyView()
        }
    }
}

#Preview("Round — choice") {
    if let player = PlayerPreviewData.players.first {
        RoundView(round: Round(number: 1, stage: .choice(player)), onChoose: { _ in }, onSkip: {}, onNext: {})
            .appPreview()
    }
}

#Preview("Round — card") {
    if let draw = PromptPreviewData.draw(.truth) {
        RoundView(round: Round(number: 2, stage: .card(draw)), onChoose: { _ in }, onSkip: {}, onNext: {})
            .appPreview()
    }
}

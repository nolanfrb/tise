import SwiftUI

/// A dealt card: what refusing costs, who it is for, and its text with player names highlighted.
struct PromptCard: View {
    let draw: Draw

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SipsChip(count: draw.prompt.sips, kind: draw.prompt.kind)
            Spacer(minLength: 16)
            VStack(spacing: 12) {
                PromptLead(draw: draw)
                    .font(AppType.headline)
                    .foregroundStyle(AppColors.textSecondary)
                Text(highlightedText)
                    .font(AppType.prompt)
                    .foregroundStyle(AppColors.textPrimary)
                    .minimumScaleFactor(0.5)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            Spacer(minLength: 16)
            GlowSymbol(name: draw.prompt.level.symbol, colors: draw.prompt.level.colors, size: 40)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(24)
        .cardSurface()
        .accessibilityElement(children: .combine)
    }

    private var highlightedText: AttributedString {
        draw.text.segments.reduce(into: AttributedString()) { result, segment in
            switch segment {
            case .text(let run):
                result += AttributedString(run)
            case .name(let name):
                var highlighted = AttributedString(name)
                highlighted.foregroundColor = AppColors.accent
                result += highlighted
            }
        }
    }
}

/// The line above a card's text: the statement's opening words, or whose truth or dare it is.
private struct PromptLead: View {
    let draw: Draw

    var body: some View {
        switch draw.prompt.kind {
        case .statement:
            Text(verbatim: Prompt.statementLead)
        case .truth:
            Text("Vérité pour \(draw.player?.name ?? "")")
        case .dare:
            Text("Action pour \(draw.player?.name ?? "")")
        case .ask:
            Text("Réponds sans filtre")
        case .vote:
            Text("Tout le monde vote")
        case .point:
            Text("Tout le monde pointe")
        case .ten:
            Text("\(draw.player?.name ?? "") lit à voix haute : \(Prompt.tenLead(score: draw.prompt.score ?? 10))")
        }
    }
}

#Preview("Card — never have I ever") {
    if let draw = PromptPreviewData.draw(.statement) {
        PromptCard(draw: draw)
            .padding()
            .appPreview()
    }
}

#Preview("Card — sans tact question") {
    if let draw = PromptPreviewData.draw(.ask) {
        PromptCard(draw: draw)
            .padding()
            .appPreview()
    }
}

#Preview("Card — c'est un 10 mais") {
    if let draw = PromptPreviewData.draw(.ten) {
        PromptCard(draw: draw)
            .padding()
            .appPreview()
    }
}

#Preview("Card — hot dare with a target") {
    if let draw = PromptPreviewData.draw(.dare) {
        PromptCard(draw: draw)
            .padding()
            .appPreview()
    }
}

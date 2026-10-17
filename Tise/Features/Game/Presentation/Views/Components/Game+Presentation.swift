import SwiftUI

extension Game {
    var title: LocalizedStringKey {
        switch self {
        case .truthOrDare: "Action ou Vérité"
        case .neverHaveIEver: "Je n'ai jamais"
        case .blunt: "Sans tact"
        }
    }

    var tileLead: LocalizedStringKey {
        switch self {
        case .truthOrDare: "Action ou"
        case .neverHaveIEver: "Je n'ai"
        case .blunt: "Sans"
        }
    }

    var tileHeadline: LocalizedStringKey {
        switch self {
        case .truthOrDare: "VÉRITÉ"
        case .neverHaveIEver: "JAMAIS"
        case .blunt: "TACT"
        }
    }

    var rules: LocalizedStringKey {
        switch self {
        case .truthOrDare:
            "Chacun son tour, le joueur choisit Action ou Vérité. Une vérité se dit franchement, une action se fait jusqu'au bout. Tu refuses ? Tu bois les tises de la carte, sans discussion. Une carte ne te plaît pas ? Glisse-la vers la gauche pour la passer. Une tise d'eau, ça compte aussi."
        case .neverHaveIEver:
            "Lisez la phrase à voix haute. Tous ceux qui l'ont déjà fait boivent les tises de la carte, puis racontent. Glissez une carte vers la gauche pour la passer. Une tise d'eau, ça compte aussi."
        case .blunt:
            "Chacun son tour, une question franche sur la table : tu réponds en désignant quelqu'un, ou tu bois les tises pour te taire. Sur un vote, si la majorité lève la main, la personne visée boit. Sur « À trois, pointez », la personne la plus désignée boit. En Couple, si vous vous désignez chacun, vous buvez tous les deux. Une carte ne te plaît pas ? Glisse-la vers la gauche pour la passer. Une tise d'eau, ça compte aussi."
        }
    }

    var headlineColor: Color {
        switch self {
        case .truthOrDare: AppColors.truth
        case .neverHaveIEver: AppColors.never
        case .blunt: AppColors.blunt
        }
    }
}

extension Audience {
    var title: LocalizedStringKey {
        switch self {
        case .friends: "Potes"
        case .couple: "Couple"
        }
    }
}

extension LevelChoice {
    func title(in game: Game) -> LocalizedStringKey {
        switch self {
        case .soft: "Soft"
        case .hot: game == .blunt ? "Hard" : "Hot"
        case .mixed: "Aléatoire"
        }
    }

    func subtitle(in game: Game) -> LocalizedStringKey {
        switch (self, game) {
        case (.soft, .blunt): "Piquant mais bienveillant, pour rire sans se fâcher"
        case (.hot, .blunt): "Plus franc, plus intime, réservé aux 18 ans et plus"
        case (.mixed, .blunt): "Un mélange de Soft et de Hard qui monte en intensité"
        case (.soft, _): "Fun et bon enfant, pour chauffer la table"
        case (.hot, _): "Pimenté et osé, réservé aux 18 ans et plus"
        case (.mixed, _): "Un mélange de Soft et de Hot qui monte en température"
        }
    }

    var symbol: String {
        switch self {
        case .soft: Level.soft.symbol
        case .hot: Level.hot.symbol
        case .mixed: "dice.fill"
        }
    }

    var colors: [Color] {
        switch self {
        case .soft: Level.soft.colors
        case .hot: Level.hot.colors
        case .mixed: [Color(hex: 0xC79BFF), Color(hex: 0xFF5FA2)]
        }
    }
}

extension Level {
    var symbol: String {
        switch self {
        case .soft: "cube.fill"
        case .hot: "flame.fill"
        }
    }

    var colors: [Color] {
        switch self {
        case .soft: [Color(hex: 0x7FE3FF), Color(hex: 0x3B6BFF)]
        case .hot: [Color(hex: 0xFFB347), Color(hex: 0xFF2E63)]
        }
    }
}

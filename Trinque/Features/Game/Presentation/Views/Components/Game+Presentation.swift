import SwiftUI

extension Game {
    var title: LocalizedStringKey {
        switch self {
        case .truthOrDare: "Action ou Vérité"
        case .neverHaveIEver: "Je n'ai jamais"
        }
    }

    var tileLead: LocalizedStringKey {
        switch self {
        case .truthOrDare: "Action ou"
        case .neverHaveIEver: "Je n'ai"
        }
    }

    var tileHeadline: LocalizedStringKey {
        switch self {
        case .truthOrDare: "VÉRITÉ"
        case .neverHaveIEver: "JAMAIS"
        }
    }

    var rules: LocalizedStringKey {
        switch self {
        case .truthOrDare:
            "Chacun son tour, le joueur choisit Action ou Vérité. Une vérité se dit franchement, une action se fait jusqu'au bout. Tu refuses ? Tu bois les gorgées de la carte, sans discussion. Une gorgée d'eau compte aussi."
        case .neverHaveIEver:
            "Lisez la phrase à voix haute. Tous ceux qui l'ont déjà fait boivent les gorgées de la carte, puis racontent. Une gorgée d'eau compte aussi."
        }
    }

    var headlineColor: Color {
        switch self {
        case .truthOrDare: AppColors.truth
        case .neverHaveIEver: AppColors.never
        }
    }
}

extension LevelChoice {
    var title: LocalizedStringKey {
        switch self {
        case .soft: "Soft"
        case .hot: "Hot"
        case .mixed: "Aléatoire"
        }
    }

    var subtitle: LocalizedStringKey {
        switch self {
        case .soft: "Fun et bon enfant, pour chauffer la table"
        case .hot: "Pimenté et osé, réservé aux 18 ans et plus"
        case .mixed: "Un mélange de Soft et de Hot qui monte en température"
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

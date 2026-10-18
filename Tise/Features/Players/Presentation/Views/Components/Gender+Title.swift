import SwiftUI

extension Gender {
    var title: LocalizedStringKey {
        switch self {
        case .female: "Femme"
        case .male: "Homme"
        }
    }

    var symbol: String {
        switch self {
        case .female: "figure.stand.dress"
        case .male: "figure.stand"
        }
    }

    var tint: Color {
        switch self {
        case .female: AppColors.female
        case .male: AppColors.male
        }
    }
}

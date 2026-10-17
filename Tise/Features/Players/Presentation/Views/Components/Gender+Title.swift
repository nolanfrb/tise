import SwiftUI

extension Gender {
    var title: LocalizedStringKey {
        switch self {
        case .female: "Femme"
        case .male: "Homme"
        }
    }
}

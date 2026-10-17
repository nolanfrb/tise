import SwiftUI

/// The home of the app: the roster and the two games.
struct HomeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                PlayersButton()
                HStack(spacing: 14) {
                    ForEach(Game.allCases, id: \.self) { game in
                        NavigationLink(value: game) {
                            GameTile(game: game)
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(AppColors.background)
        .navigationTitle("Tise")
    }
}

#Preview("Home") {
    NavigationStack {
        HomeScreen()
    }
    .appPreview()
}

import SwiftUI

/// The home of the app: the roster and the two games.
struct HomeScreen: View {
    @State private var isShowingPlayers = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                PlayersButton { isShowingPlayers = true }
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
        .sheet(isPresented: $isShowingPlayers) {
            PlayersSheet()
        }
    }
}

#Preview("Home") {
    NavigationStack {
        HomeScreen()
    }
    .appPreview()
}

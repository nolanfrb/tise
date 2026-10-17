import SwiftUI

extension View {
    /// Gives a component the session roster, the page color and the dark scheme a preview needs.
    func appPreview() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .environment(PlayerRoster(repository: AppContainer.preview.playerRepository, players: PlayerPreviewData.players))
            .preferredColorScheme(.dark)
    }
}
